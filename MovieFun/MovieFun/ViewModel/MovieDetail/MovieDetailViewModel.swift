//
//  MovieDetailViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    
    var movieDetailSectionViewModels: DynamicType<[MovieDetailSectionViewModel]>?
    
    init() {
        movieDetailSectionViewModels = DynamicType<[MovieDetailSectionViewModel]>(value: [MovieDetailSectionViewModel]())
    }
    
}
