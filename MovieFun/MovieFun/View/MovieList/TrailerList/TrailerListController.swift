//
//  TrailerListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class TrailerListController: ListController {
    
    override init() {
        super.init()
        listViewModel = TrailerMovieListViewModel()
    }
    
    override func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.listSectionViewModels?.value?.removeAll()
            listViewModel?.totalPage = totalPages
            let trailerMovieSectionVM = TrailerMovieListSectionViewModel()
            listViewModel!.listSectionViewModels?.value?.append(trailerMovieSectionVM)
            for (_, movie) in movies.enumerated() {
                let trailerMovieListRowVM = TrailerMovieListRowViewModel()
                trailerMovieListRowVM.delegate = listViewModel
                trailerMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                trailerMovieSectionVM.listRowViewModels?.value?.append(trailerMovieListRowVM)
            }
        }
    }
    
    override func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.totalPage = totalPages
            let trailerMovieSectionVM = listViewModel!.listSectionViewModels!.value![0]
            for (_, movie) in movies.enumerated() {
                let trailerMovieListRowVM = TrailerMovieListRowViewModel()
                trailerMovieListRowVM.delegate = listViewModel
                trailerMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                trailerMovieSectionVM.listRowViewModels?.value?.append(trailerMovieListRowVM)
            }
        }
    }
    
}
