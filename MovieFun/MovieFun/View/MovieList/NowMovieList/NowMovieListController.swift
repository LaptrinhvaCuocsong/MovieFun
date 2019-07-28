//
//  NowMovieListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NowMovieListController: ListController {
    
    override init() {
        super.init()
        listViewModel = NowMovieListViewModel()
    }
    
    override func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.listSectionViewModels?.value?.removeAll()
            listViewModel?.totalPage = totalPages
            let nowMovieSectionVM = NowMovieListSectionViewModel()
            listViewModel!.listSectionViewModels?.value?.append(nowMovieSectionVM)
            for (_, movie) in movies.enumerated() {
                let nowMovieListRowVM = NowMovieListRowViewModel()
                nowMovieListRowVM.delegate = listViewModel
                nowMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                nowMovieSectionVM.listRowViewModels?.value?.append(nowMovieListRowVM)
            }
        }
    }
    
    override func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.totalPage = totalPages
            let nowMovieSectionVM = listViewModel!.listSectionViewModels!.value![0]
            for (_, movie) in movies.enumerated() {
                let nowMovieListRowVM = NowMovieListRowViewModel()
                nowMovieListRowVM.delegate = listViewModel
                nowMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                nowMovieSectionVM.listRowViewModels?.value?.append(nowMovieListRowVM)
            }
        }
    }
    
}
