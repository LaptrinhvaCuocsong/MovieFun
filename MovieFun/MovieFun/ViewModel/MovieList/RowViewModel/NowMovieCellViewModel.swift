//
//  NowMovieCellViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NowMovieCellViewModel: MovieListCellViewModel {
    
    var nowMovies: DynamicType<[Movie]>?
    
    init(nowMovies: DynamicType<[Movie]>) {
        self.nowMovies = nowMovies
    }
    
}
