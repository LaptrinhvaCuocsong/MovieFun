//
//  MovieListSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieListSectionViewModel {
    
    var rowViewModels: DynamicType<[MovieListCellViewModel]>?
    
    init() {
        rowViewModels = DynamicType<[MovieListCellViewModel]>(value: [MovieListCellViewModel]())
    }
    
}
