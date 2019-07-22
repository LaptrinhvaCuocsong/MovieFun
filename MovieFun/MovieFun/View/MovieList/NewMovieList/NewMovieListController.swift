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
        MovieService.share.fetchNewMovie(page: newMovieListViewModel!.currentPage!.value!, language: .en_US) {[weak self] (totalPages, movies) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.buildViewModel(totalPages: totalPages, movies: movies)
            strongSelf.newMovieListViewModel?.isFetching?.value = false
            let currentPage = strongSelf.newMovieListViewModel!.currentPage!.value!
            strongSelf.newMovieListViewModel?.currentPage?.value = currentPage + 1
        }
    }
    
    func loadMore() {
        newMovieListViewModel?.isLoadMore?.value = true
        MovieService.share.fetchNewMovie(page: newMovieListViewModel!.currentPage!.value!, language: .en_US) {[weak self] (totalPages, movies) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.newMovieListViewModel?.isLoadMore?.value = false
            strongSelf.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
            let currentPage = strongSelf.newMovieListViewModel!.currentPage!.value!
            strongSelf.newMovieListViewModel?.currentPage?.value = currentPage + 1
        }
    }
    
    private func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            newMovieListViewModel?.totalPage = totalPages
            let newMovieSectionVM = NewMovieListSectionViewModel()
            newMovieListViewModel!.newMovieListSectionViewModels?.value?.append(newMovieSectionVM)
            for (_, movie) in movies.enumerated() {
                let newMovieListRowVM = NewMovieListRowViewModel()
                newMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                newMovieSectionVM.newMovieListRowViewModels?.value?.append(newMovieListRowVM)
            }
        }
    }
    
    private func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            newMovieListViewModel?.totalPage = totalPages
            let newMovieSectionVM = newMovieListViewModel!.newMovieListSectionViewModels!.value![0]
            for (_, movie) in movies.enumerated() {
                let newMovieListRowVM = NewMovieListRowViewModel()
                newMovieListRowVM.movie = DynamicType<Movie>(value: movie)
                newMovieSectionVM.newMovieListRowViewModels?.value?.append(newMovieListRowVM)
            }
        }
    }
    
}
