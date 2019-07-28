//
//  NewMovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NewMovieListViewModel: ListViewModel {
    
    override init() {
        super.init()
        listSectionViewModels = DynamicType<[ListSectionViewModel]>(value: [NewMovieListSectionViewModel]())
        url = MovieService.NEW_MOVIE_URL
    }
    
}
