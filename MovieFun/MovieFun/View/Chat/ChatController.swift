//
//  ChatController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class ChatController {
    
    var chatViewModel: ChatViewModel?
    var dateFormatter: DateFormatter!
    var messages: [Message]?
    
    init() {
        chatViewModel = ChatViewModel()
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    func start() {
        if let movieId = chatViewModel?.movieId {
            chatViewModel?.isFetching?.value = true
            ChatService.share.fetchChatMessages(movieId: movieId) {[weak self] (messages, error) in
                if error == nil {
                    if let messages = messages, let groupMessages = self?.createGroupMessage(messages: messages) {
                        self?.buildViewModels(groupMessages)
                    }
                    self?.messages = messages
                    self?.chatViewModel?.isFetching?.value = false
                }
            }
            ChatService.share.addListener(movieId: movieId) {[weak self] (messageChanges, error) in
                if error == nil {
                    if let messageChanges = messageChanges, let accountId = AccountService.share.getAccountId() {
                        var haveOtherAccount = false
                        for message in messageChanges {
                            if let accId = message.accountId {
                                if accId != accountId {
                                    self?.messages?.append(message)
                                    haveOtherAccount = true
                                }
                            }
                        }
                        if haveOtherAccount {
                            if let messages = self?.messages, let groupMessages = self?.createGroupMessage(messages: messages) {
                                self?.buildViewModels(groupMessages)
                                self?.chatViewModel?.receiveMessageSuccess?.value = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        if let movieId = chatViewModel?.movieId {
            ChatService.share.removeListener(movieId: movieId)
        }
    }
    
    func addMessage(_ text: String) {
        chatViewModel?.haveAddMessage?.value = false
        var message = Message()
        message.accountId = AccountService.share.getAccountId()
        message.accountName = AccountService.share.getAccountName()
        message.sendDate = Date()
        message.content = text
        message.addMessageSuccess = false
        if var messages = self.messages {
            messages.append(message)
            buildViewModels(createGroupMessage(messages: messages))
            chatViewModel?.haveAddMessage?.value = true
            if let movieId = chatViewModel?.movieId {
                chatViewModel?.addMessageSuccess?.value = false
                ChatService.share.addChatMessage(movieId: movieId, message: message) {[weak self] (isSuccess, error) in
                    if error == nil && isSuccess ?? false {
                        message.addMessageSuccess = true
                        self?.buildViewModels(self!.createGroupMessage(messages: messages))
                        self?.chatViewModel?.addMessageSuccess?.value = true
                    }
                }
            }
        }
    }
    
    private func buildViewModels(_ groupMessages: [[Message]]) {
        chatViewModel?.sectionViewModels?.value?.removeAll()
        for groupMessage in groupMessages {
            let sectionVM = ChatSectionViewModel()
            chatViewModel?.sectionViewModels?.value?.append(sectionVM)
            for (i, message) in groupMessage.enumerated() {
                if let sendDate = message.sendDate {
                    if sectionVM.sendDateStr == nil {
                        sectionVM.sendDateStr = dateFormatter.string(from: sendDate)
                    }
                    let accountId = AccountService.share.getAccountId()!
                    var rowVM: ChatRowViewModel!
                    if (accountId == message.accountId!) {
                        rowVM = ChatRightRowViewModel(addMessageSuccess: message.addMessageSuccess)
                    }
                    else {
                        rowVM = ChatLeftRowViewModel()
                    }
                    rowVM!.previousMessage = i == 0 ? nil : groupMessage[i-1]
                    rowVM!.currentMessage = message
                    sectionVM.rowViewModels?.value?.append(rowVM)
                }
            }
        }
    }
    
    private func createGroupMessage(messages: [Message]) -> [[Message]] {
        var groupMessages = [[Message]]()
        var dictinary:[TimeInterval:[Message]] = [TimeInterval:[Message]]()
        for message in messages {
            if let sendDate = message.sendDate {
                if let date = dateFormatter.date(from: dateFormatter.string(from: sendDate)) {
                    let s = date.timeIntervalSince1970
                    if dictinary[s] == nil {
                        dictinary[s] = [Message]()
                    }
                    dictinary[s]?.append(message)
                }
            }
        }
        for key in dictinary.keys.sorted() {
            groupMessages.append(dictinary[key]!)
        }
        return groupMessages
    }
    
    func cellIdentify(with rowViewModel: ChatRowViewModel) -> String? {
        switch rowViewModel {
        case is ChatLeftRowViewModel:
            return ChatTableViewCell.cellLeftIdentify
        case is ChatRightRowViewModel:
            return ChatTableViewCell.cellRightIdentify
        default:
            return nil
        }
    }
    
}
