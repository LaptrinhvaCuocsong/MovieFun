//
//  NewMovieListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NewMovieListController: ListController {
    
    override init() {
        super.init()
        listViewModel = NewMovieListViewModel()
    }
    
    override func buildViewModel(totalPages: Int, movies: [Movie]) {
        listViewModel?.listSectionViewModels?.value?.removeAll()
        listViewModel?.totalPage = totalPages
        let newMovieSectionVM = NewMovieListSectionViewModel()
        listViewModel!.listSectionViewModels?.value?.append(newMovieSectionVM)
        for (_, movie) in movies.enumerated() {
            let newMovieListRowVM = NewMovieListRowViewModel()
            newMovieListRowVM.delegate = listViewModel
            newMovieListRowVM.movie = DynamicType<Movie>(value: movie)
            newMovieSectionVM.listRowViewModels?.value?.append(newMovieListRowVM)
        }
    }
    
    override func buildViewModelAfterLoadMore(totalPages: Int, movies: [Movie]) {
        listViewModel?.totalPage = totalPages
        let newMovieSectionVM = listViewModel!.listSectionViewModels!.value![0]
        for (_, movie) in movies.enumerated() {
            let newMovieListRowVM = NewMovieListRowViewModel()
            newMovieListRowVM.delegate = listViewModel
            newMovieListRowVM.movie = DynamicType<Movie>(value: movie)
            newMovieSectionVM.listRowViewModels?.value?.append(newMovieListRowVM)
        }
    }
    
}
