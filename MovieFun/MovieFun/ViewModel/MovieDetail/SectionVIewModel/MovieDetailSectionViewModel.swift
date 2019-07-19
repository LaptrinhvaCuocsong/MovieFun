//
//  MovieDetailSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieDetailSectionViewModel {
    
    var movieDetailRowViewModels: DynamicType<[MovieDetailRowViewModel]>?
    
    init() {
        movieDetailRowViewModels = DynamicType<[MovieDetailRowViewModel]>(value: [MovieDetailRowViewModel]())
    }
    
}
