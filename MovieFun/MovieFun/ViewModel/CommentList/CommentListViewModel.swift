//
//  CommentListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class CommentListViewModel {
    
    var isFetching: DynamicType<Bool>?
    var haveChangeData: DynamicType<Bool>?
    var commentListSectionViewModels: DynamicType<[CommentListSectionViewModel]>?
    
    init() {
        haveChangeData = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        commentListSectionViewModels = DynamicType<[CommentListSectionViewModel]>(value: [CommentListSectionViewModel]())
    }
    
}
