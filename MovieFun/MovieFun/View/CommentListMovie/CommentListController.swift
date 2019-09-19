//
//  CommentListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class CommentListController {

    var commentListViewModel: CommentListViewModel?
    var groupComments: [GroupComment]?
    var didStart = false
    
    init() {
        commentListViewModel = CommentListViewModel()
    }
    
    deinit {
        removeListener()
    }
    
    private func removeListener() {
        CommentListService.share.removeListener()
        if let groupComments = self.groupComments {
            for groupComment in groupComments {
                if let movie = groupComment.movie, let movieId = movie.id {
                    ChatService.share.removeListener(movieId: "\(movieId)")
                }
            }
        }
    }
    
    func start() {
        didStart = false
        removeListener()
        commentListViewModel?.isFetching?.value = true
        CommentListService.share.fetchGroupComments {[weak self] (groupComments, error) in
            if error == nil {
                if let groupComments = groupComments {
                    self?.buildViewModels(groupComments: groupComments)
                    for groupComment in groupComments {
                        if let movie = groupComment.movie {
                            self?.initListenerForMovieChat(movie: movie)
                        }
                    }
                    self?.initListenerForGroupChat()
                    self?.groupComments = groupComments
                }
            }
            self?.commentListViewModel?.isFetching?.value = false
        }
    }
    
    func initListenerForMovieChat(movie: Movie) {
        ChatService.share.addListener(movieId: "\(movie.id!)") {[weak self] (messageChanges, error) in
            if !(self?.didStart ?? false) {
                self?.didStart = true
                return
            }
            if error == nil {
                let messageChanges = messageChanges?.sorted(by: { (mess1, mess2) -> Bool in
                    return mess1.sendDate! < mess2.sendDate!
                })
                if let messageChange = messageChanges?.last {
                    let groupComment = GroupComment()
                    groupComment.movie = movie
                    groupComment.newMessage = messageChange.content
                    groupComment.newSenderName = messageChange.accountName
                    groupComment.sendDate = messageChange.sendDate
                    CommentListService.share.addGroupComment(groupMessage: groupComment, completion: nil)
                }
            }
        }
    }
    
    func initListenerForGroupChat() {
        CommentListService.share.addListener {[weak self] (groupComments, error) in
            if !(self?.didStart ?? false) {
                self?.didStart = true
                return
            }
            if error == nil {
                if let groupComments = groupComments?.sorted(by: { (group1, group2) -> Bool in
                    return group1.sendDate! > group2.sendDate!
                }) {
                    self?.commentListViewModel?.haveChangeData?.value = false
                    self?.buildViewModels(groupComments: groupComments)
                    self?.commentListViewModel?.haveChangeData?.value = true
                    self?.groupComments = groupComments
                }
            }
        }
    }
    
    func addGroupComment(groupMessage: GroupComment, completionWhenAdd: ((Bool?, Error?) -> Void)?) {
        CommentListService.share.addGroupComment(groupMessage: groupMessage, completion: completionWhenAdd)
    }
    
    func cellIdentify(rowVM: CommentListBaseRowViewModel) -> String? {
        switch rowVM {
        case is CommentListHeaderRowViewModel:
            return CommentListHeaderTableViewCell.cellIdentify
        case is CommentListRowViewModel:
            return CommentListTableViewCell.cellIdentify
        default:
            return nil
        }
    }
    
    private func buildViewModels(groupComments: [GroupComment]) {
        commentListViewModel?.commentListSectionViewModels?.value?.removeAll()
        let sectionVM = CommentListSectionViewModel()
        commentListViewModel?.commentListSectionViewModels?.value?.append(sectionVM)
        for groupComment in groupComments {
            let rowVM = CommentListRowViewModel()
            rowVM.groupComment = DynamicType<GroupComment>(value: groupComment)
            sectionVM.commentListRowViewModels?.value?.append(rowVM)
        }
        if groupComments.count == 0 {
            let headerVM = CommentListHeaderRowViewModel()
            sectionVM.commentListRowViewModels?.value?.append(headerVM)
        }
    }
    
}
