//
//  SearchMovieSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/31/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class SearchMovieSectionViewModel {
    
    var rowViewModels: DynamicType<[SearchMovieBaseRowViewModel]>?
    
    init() {
        rowViewModels = DynamicType<[SearchMovieBaseRowViewModel]>(value: [SearchMovieBaseRowViewModel]())
    }
    
}
