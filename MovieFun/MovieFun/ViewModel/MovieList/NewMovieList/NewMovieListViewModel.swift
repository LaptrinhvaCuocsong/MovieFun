//
//  NewMovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NewMovieListViewModel {
    
    var isLoadMore: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var newMovieListSectionViewModels: DynamicType<[NewMovieListSectionViewModel]>?
    var totalPage = 1
    var currentPage: DynamicType<Int>?
    
    init() {
        isLoadMore = DynamicType<Bool>(value: false)
        currentPage = DynamicType<Int>(value: 1)
        isFetching = DynamicType<Bool>(value: false)
        newMovieListSectionViewModels = DynamicType<[NewMovieListSectionViewModel]>(value: [NewMovieListSectionViewModel]())
    }
    
}
