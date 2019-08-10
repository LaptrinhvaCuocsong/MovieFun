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
    
    init() {
        commentListViewModel = CommentListViewModel()
    }
    
    func start() {
        commentListViewModel?.isFetching?.value = true
        CommentListService.share.fetchGroupComments {[weak self] (groupComments, error) in
            if error == nil {
                if let groupComments = groupComments {
                    self?.buildViewModels(groupComments: groupComments)
                }
            }
            self?.commentListViewModel?.isFetching?.value = false
        }
    }
    
    func checkGroupComment(movieId: Int, completionWhenAdd: ((Bool?, Error?) -> Void)?) {
        CommentListService.share.checkGroupComment(movieId: "\(movieId)") { (exist, error) in
            if error == nil {
                if let exist = exist {
                    if !exist {
                        CommentListService.share.addGroupComment(movieId: "\(movieId)", completion: completionWhenAdd)
                    }
                }
            }
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
    }
    
}
