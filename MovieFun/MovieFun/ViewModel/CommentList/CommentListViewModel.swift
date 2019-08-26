//
//  CommentListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class CommentListViewModel {
    
    var isHiddenSearchBar: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var commentListSectionViewModels: DynamicType<[CommentListSectionViewModel]>?
    
    init() {
        isHiddenSearchBar = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        commentListSectionViewModels = DynamicType<[CommentListSectionViewModel]>(value: [CommentListSectionViewModel]())
    }
    
}
