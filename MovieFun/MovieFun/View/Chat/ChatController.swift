//
//  ChatController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import Photos

class ChatController {
    
    var chatViewModel: ChatViewModel?
    private var messages: [Message]?
    private var didStart = false
    
    init() {
        chatViewModel = ChatViewModel()
    }
    
    deinit {
        if let movieId = chatViewModel?.movieId {
            ChatService.share.removeListener(movieId: movieId)
        }
    }
    
    func start() {
        didStart = false
        if let movieId = chatViewModel?.movieId {
            chatViewModel?.isFetching?.value = true
            ChatService.share.fetchChatMessages(movieId: movieId) {[weak self] (messages, error) in
                if error == nil {
                    if let messages = messages, let groupMessages = self?.createGroupMessage(messages: messages) {
                        self?.buildViewModels(groupMessages)
                    }
                    self?.chatViewModel?.isFetching?.value = false
                    self?.messages = messages
                }
                self?.initListener(movieId: movieId)
            }
        }
    }
    
    private func initListener(movieId: String) {
        ChatService.share.addListener(movieId: movieId) {[weak self] (messageChanges, error) in
            if !(self?.didStart ?? false) {
                self?.didStart = true
                return
            }
            if error == nil {
                if let messageChanges = messageChanges, let accountId = AccountService.share.getAccountId() {
                    var haveAddMessage = false
                    let messageChanges = messageChanges.sorted(by: { (mess1, mess2) -> Bool in
                        return mess1.sendDate! < mess2.sendDate!
                    })
                    for message in messageChanges {
                        if !(self?.checkExistMessage(message: message) ?? true) {
                            self?.messages?.append(message)
                            var rowVM: ChatRowViewModel?
                            if message.accountId! != accountId {
                                rowVM = ChatLeftRowViewModel()
                            }
                            else {
                                rowVM = ChatRightRowViewModel()
                            }
                            rowVM?.currentMessage = message
                            self?.addRowViewModel(rowVM: rowVM!)
                            haveAddMessage = true
                        }
                    }
                    self?.chatViewModel?.haveAddMessage?.value = haveAddMessage
                }
            }
        }
    }
    
    func addMessage(_ text: String, addSuccess: ((Message) -> Void)?) {
        chatViewModel?.haveAddMessage?.value = false
        var message = Message()
        message.accountId = AccountService.share.getAccountId()
        message.accountName = AccountService.share.getAccountName()
        message.sendDate = Utils.share.getCurrentDate()
        message.content = text
        messages?.append(message)
        let rowVM = ChatRightRowViewModel(addMessageSuccess: false)
        rowVM.currentMessage = message
        addRowViewModel(rowVM: rowVM)
        chatViewModel?.haveAddMessage?.value = true
        if let movieId = chatViewModel?.movieId {
            ChatService.share.addChatMessage(movieId: movieId, message: message) { (messageId, error) in
                if error == nil && messageId != nil {
                    message.messageId = messageId
                    rowVM.addMessagesSuccess?.value = true
                    if addSuccess != nil {
                        addSuccess!(message)
                    }
                }
                else {
                    rowVM.addMessagesSuccess?.value = false
                }
            }
        }
    }
    
    func addMessageImage(asset: PHAsset, addSuccess: ((Message) -> Void)?) {
        let phContentEditInputRequestOptions = PHContentEditingInputRequestOptions()
        phContentEditInputRequestOptions.isNetworkAccessAllowed = false
        asset.requestContentEditingInput(with: phContentEditInputRequestOptions) {[weak self] (phContentInput, _) in
            if let url = phContentInput?.fullSizeImageURL {
                if let fileName = Utils.share.getFileName(from: url) {
                    self?.chatViewModel?.haveAddMessage?.value = false
                    var message = Message()
                    message.accountId = AccountService.share.getAccountId()
                    message.accountName = AccountService.share.getAccountName()
                    message.sendDate = Utils.share.getCurrentDate()
                    message.isMessageImage = true
                    message.imageName = fileName
                    self?.messages?.append(message)
                    let rowVM = ChatRightRowViewModel(addMessageSuccess: false)
                    rowVM.phAsset = asset
                    rowVM.currentMessage = message
                    self?.addRowViewModel(rowVM: rowVM)
                    self?.chatViewModel?.haveAddMessage?.value = true
                    if let movieId = self?.chatViewModel?.movieId {
                        ChatService.share.addChatMessage(movieId: movieId, message: message) { (messageId, error) in
                            if error == nil && messageId != nil {
                                message.messageId = messageId
                                PhotoService.share.fetchImage(phAsset: asset, targetSize: nil, completion: { (image) in
                                    if let image = image, let imageData = StorageService.share.getData(image: image) {
                                        StorageService.share.putImage(imageName: message.imageName!, imageData: imageData, completion: { (metadata, error) in
                                            if error == nil && metadata != nil {
                                                rowVM.addMessagesSuccess?.value = true
                                                // if message is message image then add imageName to imageNames
                                                if let imageName = rowVM.currentMessage?.imageName, !Utils.trim(imageName).isEmpty {
                                                    let asset = (accountId: message.accountId!, imageName: message.imageName!)
                                                    self?.chatViewModel?.assets?.value?.append(asset)
                                                }
                                                if addSuccess != nil {
                                                    addSuccess!(message)
                                                }
                                            }
                                            else {
                                                rowVM.addMessagesSuccess?.value = false
                                            }
                                        })
                                    }
                                    else {
                                        rowVM.addMessagesSuccess?.value = false
                                    }
                                })
                            }
                            else {
                                rowVM.addMessagesSuccess?.value = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func addRowViewModel(rowVM: ChatRowViewModel) {
        rowVM.delegate = chatViewModel
        if let lastSection = chatViewModel?.sectionViewModels?.value?.last {
            if let headerVM = lastSection.rowViewModels?.value?.first as? ChatHeaderRowViewModel, let timeStr = headerVM.sendDateStr {
                if timeStr == Utils.share.stringFromDate(dateFormat: Utils.YYYYMMDD, date: rowVM.currentMessage!.sendDate!) {
                    if let previousRowVM = lastSection.rowViewModels?.value?.last {
                        rowVM.previousMessage = previousRowVM.currentMessage
                    }
                    lastSection.rowViewModels?.value?.append(rowVM)
                    return
                }
            }
        }
        let sectionVM = ChatSectionViewModel()
        let headerVM = ChatHeaderRowViewModel()
        headerVM.sendDateStr = Utils.share.stringFromDate(dateFormat: Utils.YYYYMMDD, date: rowVM.currentMessage!.sendDate!)
        sectionVM.rowViewModels?.value?.append(headerVM)
        sectionVM.rowViewModels?.value?.append(rowVM)
        chatViewModel?.sectionViewModels?.value?.append(sectionVM)
    }
    
    private func buildViewModels(_ groupMessages: [[Message]]) {
        for groupMessage in groupMessages {
            let sectionVM = ChatSectionViewModel()
            chatViewModel?.sectionViewModels?.value?.append(sectionVM)
            var headerVM: ChatHeaderRowViewModel?
            for (i, message) in groupMessage.enumerated() {
                if let sendDate = message.sendDate {
                    if headerVM == nil {
                        headerVM = ChatHeaderRowViewModel()
                        headerVM?.sendDateStr = Utils.share.stringFromDate(dateFormat: Utils.YYYYMMDD, date: sendDate)
                        sectionVM.rowViewModels?.value?.append(headerVM!)
                    }
                    let accountId = AccountService.share.getAccountId()!
                    var rowVM: ChatRowViewModel!
                    if (accountId == message.accountId!) {
                        rowVM = ChatRightRowViewModel()
                    }
                    else {
                        rowVM = ChatLeftRowViewModel()
                    }
                    rowVM!.previousMessage = i == 0 ? nil : groupMessage[i-1]
                    rowVM!.currentMessage = message
                    rowVM.delegate = chatViewModel
                    sectionVM.rowViewModels?.value?.append(rowVM)
                    if let imageName = rowVM.currentMessage?.imageName, !Utils.trim(imageName).isEmpty {
                        let asset = (accountId: accountId, imageName: imageName)
                        chatViewModel?.assets?.value?.append(asset)
                    }
                }
            }
        }
    }
    
    private func checkExistMessage(message: Message) -> Bool {
        if let messages = self.messages {
            for mess in messages {
                if mess.accountId! == message.accountId! && mess.sendDate! == message.sendDate! {
                    return true
                }
            }
        }
        return false
    }
    
    private func createGroupMessage(messages: [Message]) -> [[Message]] {
        var groupMessages = [[Message]]()
        var dictinary:[TimeInterval:[Message]] = [TimeInterval:[Message]]()
        for message in messages {
            if let sendDate = message.sendDate {
                if let sendDateStr = Utils.share.stringFromDate(dateFormat: Utils.YYYYMMDD, date: sendDate), let date = Utils.share.dateFromString(dateFormat: Utils.YYYYMMDD, string: sendDateStr) {
                    let s = date.timeIntervalSince1970
                    if dictinary[s] == nil {
                        dictinary[s] = [Message]()
                    }
                    dictinary[s]?.append(message)
                }
            }
        }
        for key in dictinary.keys.sorted() {
            groupMessages.append(dictinary[key]!.sorted(by: { (mess1, mess2) -> Bool in
                return mess1.sendDate! < mess2.sendDate!
            }))
        }
        return groupMessages
    }
    
    func cellIdentify(with rowViewModel: ChatRowViewModel) -> String? {
        switch rowViewModel {
        case is ChatLeftRowViewModel:
            return ChatTableViewCell.cellLeftIdentify
        case is ChatRightRowViewModel:
            return ChatTableViewCell.cellRightIdentify
        case is ChatHeaderRowViewModel:
            return HeaderTableViewCell.cellIdentify
        default:
            return nil
        }
    }
    
    //MARK: Image chat collection
    
    func fetchAssetImages() {
        chatViewModel?.isFetchingAssets?.value = true
        let phResult = PHAsset.fetchAssets(with: .image, options: nil)
        let indexSet = IndexSet(0..<phResult.count)
        let phAssets = phResult.objects(at: indexSet)
        chatViewModel?.phassets = phAssets.map({ (asset) -> PHAssetWrapper in
            return PHAssetWrapper(asset: asset)
        })
        chatViewModel?.isFetchingAssets?.value = false
    }
    
}
