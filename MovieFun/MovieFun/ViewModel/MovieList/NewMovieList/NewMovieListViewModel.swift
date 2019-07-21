//
//  NewMovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NewMovieListViewModel {
    
    var isFetching: DynamicType<Bool>?
    var newMovieListSectionViewModels: DynamicType<[NewMovieListSectionViewModel]>?
    
    init() {
        isFetching = DynamicType<Bool>(value: false)
        newMovieListSectionViewModels = DynamicType<[NewMovieListSectionViewModel]>(value: [NewMovieListSectionViewModel]())
    }
    
}
