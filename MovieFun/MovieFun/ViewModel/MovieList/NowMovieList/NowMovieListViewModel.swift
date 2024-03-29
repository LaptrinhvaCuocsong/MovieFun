//
//  NowMovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/24/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NowMovieListViewModel: ListViewModel {
    
    override init() {
        super.init()
        listSectionViewModels = DynamicType<[ListSectionViewModel]>(value: [NowMovieListSectionViewModel]())
        url = MovieService.NOW_MOVIE_URL
    }
    
}
