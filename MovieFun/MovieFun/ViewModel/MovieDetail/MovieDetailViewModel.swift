//
//  MovieDetailViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    
    var isFetching: DynamicType<Bool>?
    var movieId: DynamicType<String>?
    var movieDetailSectionViewModels: DynamicType<[MovieDetailSectionViewModel]>?
    
    init() {
        isFetching = DynamicType<Bool>(value: false)
        movieId = DynamicType<String>(value: "")
        movieDetailSectionViewModels = DynamicType<[MovieDetailSectionViewModel]>(value: [MovieDetailSectionViewModel]())
    }
    
}
