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
        commentListViewModel?.isHiddenSearchBar?.value = false
        commentListViewModel?.commentListSectionViewModels?.value?.removeAll()
        let sectionVM = CommentListSectionViewModel()
        commentListViewModel?.commentListSectionViewModels?.value?.append(sectionVM)
        for groupComment in groupComments {
            let rowVM = CommentListRowViewModel()
            rowVM.groupComment = DynamicType<GroupComment>(value: groupComment)
            sectionVM.commentListRowViewModels?.value?.append(rowVM)
        }
        if groupComments.count == 0 {
            commentListViewModel?.isHiddenSearchBar?.value = true
            let headerVM = CommentListHeaderRowViewModel()
            sectionVM.commentListRowViewModels?.value?.append(headerVM)
        }
    }
    
}
