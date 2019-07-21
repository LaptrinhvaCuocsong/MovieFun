//
//  NewMovieListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NewMovieListController {
    
    var newMovieListViewModel: NewMovieListViewModel?
    
    init() {
        newMovieListViewModel = NewMovieListViewModel()
    }
    
    func start() {
        newMovieListViewModel?.isFetching?.value = true
        MovieService.share.fetchNewMovie(page: 1, language: .en_US) {[weak self] (movies) in
            self?.buildViewModel(movies: movies)
            self?.newMovieListViewModel?.isFetching?.value = false
        }
    }
    
    private func buildViewModel(movies: [Movie]?) {
        if let movies = movies {
            let newMovieSectionVM = NewMovieListSectionViewModel()
            newMovieListViewModel!.newMovieListSectionViewModels?.value?.append(newMovieSectionVM)
            for (_, movie) in movies.enumerated() {
                let newMovieListRowVM = NewMovieListRowViewModel()
                newMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                newMovieSectionVM.newMovieListRowViewModels?.value?.append(newMovieListRowVM)
            }
        }
    }
    
}
