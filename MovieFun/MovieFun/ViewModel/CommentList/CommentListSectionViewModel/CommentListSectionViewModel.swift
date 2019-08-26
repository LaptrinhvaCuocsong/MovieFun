//
//  CommentListSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class CommentListSectionViewModel {
    
    var commentListRowViewModels: DynamicType<[CommentListBaseRowViewModel]>?
    
    init() {
        commentListRowViewModels = DynamicType<[CommentListBaseRowViewModel]>(value: [CommentListBaseRowViewModel]())
    }
    
}
