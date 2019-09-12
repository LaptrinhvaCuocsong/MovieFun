//
//  SearchMovieController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/31/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class SearchMovieController {
    
    var searchMovieViewModel: SearchMovieViewModel?
    
    init() {
        searchMovieViewModel = SearchMovieViewModel()
    }
    
    func cellIdentify(rowVM: SearchMovieBaseRowViewModel) -> String? {
        switch rowVM {
        case is SearchMovieRowViewModel:
            return SearchMovieTableViewCell.cellIdentify
        case is SearchMovieHeaderRowViewModel:
            return SearchHeaderTableViewCell.cellIdentify
        default:
            return nil
        }
    }
    
    func start() {
        searchMovieViewModel?.searchText = nil
        searchMovieViewModel?.isFetching?.value = true
        MovieService.share.fetchMovie(url: searchMovieViewModel!.url!, language: .en_US, page: 1) {[weak self] (totalPage, movies, error) in
            if let _ = error {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                return
            }
            if let movies = movies, let totalPage = totalPage {
                self?.buildViewModels(movies: movies)
                self?.searchMovieViewModel?.totalPage = totalPage
                self?.searchMovieViewModel?.currentPage?.value = 2
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for rowVM in rowVMs {
                                    if let movieId = rowVM.movie?.value?.id {
                                        rowVM.isFavoriteMovie?.value = isFavoriteMovies[movieId] ?? false
                                    }
                                    else {
                                        rowVM.isFavoriteMovie?.value = false
                                    }
                                }
                            }
                        }
                        self?.searchMovieViewModel?.isFetching?.value = false
                    })
                }
                else {
                    self?.searchMovieViewModel?.isFetching?.value = false
                }
            }
            else {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                self?.searchMovieViewModel?.isFetching?.value = false
            }
        }
    }
    
    func search(searchText: String) {
        searchMovieViewModel?.searchText = searchText
        searchMovieViewModel?.isFetching?.value = true
        MovieService.share.searchMovie(searchText: searchText, page: 1, language: .en_US) {[weak self] (totalPage, movies, error) in
            if let _ = error {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                return
            }
            if let movies = movies, let totalPage = totalPage {
                self?.buildViewModels(movies: movies)
                self?.searchMovieViewModel?.totalPage = totalPage
                self?.searchMovieViewModel?.currentPage?.value = 2
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for rowVM in rowVMs {
                                    if let movieId = rowVM.movie?.value?.id {
                                        rowVM.isFavoriteMovie?.value = isFavoriteMovies[movieId] ?? false
                                    }
                                    else {
                                        rowVM.isFavoriteMovie?.value = false
                                    }
                                }
                            }
                        }
                        self?.searchMovieViewModel?.isFetching?.value = false
                    })
                }
                else {
                    self?.searchMovieViewModel?.isFetching?.value = false
                }
            }
            else {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                self?.searchMovieViewModel?.isFetching?.value = false
            }
        }
    }
    
    func loadMore(_ dispatchTime: DispatchTime) {
        searchMovieViewModel?.isLoadMore?.value = true
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            if let searchText = strongSelf.searchMovieViewModel?.searchText {
                strongSelf.loadMoreForMovieWhenSearch(searchText: searchText)
            }
            else {
                strongSelf.loadMoreForNewMovie()
            }
        }
    }
    
    private func loadMoreForMovieWhenSearch(searchText: String) {
        MovieService.share.searchMovie(searchText: searchText, page: searchMovieViewModel!.currentPage!.value!, language: .en_US) {[weak self] (totalPages, movies, error) in
            if let _ = error {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                return
            }
            if let totalPages = totalPages, let movies = movies {
                self?.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
                let currentPage = self!.searchMovieViewModel!.currentPage!.value!
                self?.searchMovieViewModel?.currentPage?.value = currentPage + 1
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for rowVM in rowVMs {
                                    if let movieId = rowVM.movie?.value?.id {
                                        rowVM.isFavoriteMovie?.value = isFavoriteMovies[movieId] ?? false
                                    }
                                    else {
                                        rowVM.isFavoriteMovie?.value = false
                                    }
                                }
                            }
                        }
                        self?.searchMovieViewModel?.isLoadMore?.value = false
                    })
                }
                else {
                    self?.searchMovieViewModel?.isLoadMore?.value = false
                }
            }
            else {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                self?.searchMovieViewModel?.isLoadMore?.value = false
            }
        }
    }
    
    func loadFavoriteMovies() {
        if let rowVMs = getRowVMFromListViewModel() {
            FavoriteMovieService.share.checkFavoriteMovie(movieIds: getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                if error == nil {
                    if let isFavoriteMovies = isFavoriteMovies {
                        for rowVM in rowVMs {
                            if let movieId = rowVM.movie?.value?.id {
                                rowVM.isFavoriteMovie?.value = isFavoriteMovies[movieId] ?? false
                            }
                            else {
                                rowVM.isFavoriteMovie?.value = false
                            }
                        }
                    }
                }
            })
        }
    }
    
    private func loadMoreForNewMovie() {
        MovieService.share.fetchMovie(url: searchMovieViewModel!.url!, language: .en_US, page: searchMovieViewModel!.currentPage!.value!, completion: {[weak self] (totalPages, movies, error) in
            guard let _ = error else {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                return
            }
            if let totalPages = totalPages, let movies = movies {
                self?.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
                let currentPage = self!.searchMovieViewModel!.currentPage!.value!
                self?.searchMovieViewModel?.currentPage?.value = currentPage + 1
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for rowVM in rowVMs {
                                    if let movieId = rowVM.movie?.value?.id {
                                        rowVM.isFavoriteMovie?.value = isFavoriteMovies[movieId] ?? false
                                    }
                                    else {
                                        rowVM.isFavoriteMovie?.value = false
                                    }
                                }
                            }
                        }
                        self?.searchMovieViewModel?.isLoadMore?.value = false
                    })
                }
                else {
                    self?.searchMovieViewModel?.isLoadMore?.value = false
                }
            }
            else {
                self?.searchMovieViewModel?.isLoadFail?.value = true
                self?.searchMovieViewModel?.isLoadMore?.value = false
            }
        })
    }
    
    private func buildViewModels(movies: [Movie]) {
        searchMovieViewModel?.sectionViewModels?.value?.removeAll()
        let sectionVM = SearchMovieSectionViewModel()
        searchMovieViewModel?.sectionViewModels?.value?.append(sectionVM)
        for movie in movies {
            let rowVM = SearchMovieRowViewModel()
            rowVM.delegate = searchMovieViewModel
            rowVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.rowViewModels?.value?.append(rowVM)
        }
        if movies.count == 0 {
            let headerVM = SearchMovieHeaderRowViewModel()
            sectionVM.rowViewModels?.value?.append(headerVM)
        }
    }
    
    private func buildViewModelAfterLoadMore(totalPages: Int, movies: [Movie]) {
        searchMovieViewModel?.totalPage = totalPages
        let sectionVM = searchMovieViewModel!.sectionViewModels!.value![0]
        for (_, movie) in movies.enumerated() {
            let rowVM = SearchMovieRowViewModel()
            rowVM.delegate = searchMovieViewModel
            rowVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.rowViewModels?.value?.append(rowVM)
        }
    }
    
    private func getRowVMFromListViewModel() -> [SearchMovieRowViewModel]? {
        var rowViewModels: [SearchMovieRowViewModel]?
        if let sectionVMs = self.searchMovieViewModel?.sectionViewModels?.value {
            rowViewModels = [SearchMovieRowViewModel]()
            for sectionVM in sectionVMs {
                if let rowVMs = sectionVM.rowViewModels?.value as? [SearchMovieRowViewModel] {
                    rowViewModels?.append(contentsOf: rowVMs)
                }
            }
            return rowViewModels
        }
        return nil
    }
    
    private func getMovieIdsFromListViewModel() -> [Int]? {
        var movieIds: [Int]?
        if let sectionVMs = self.searchMovieViewModel?.sectionViewModels?.value {
            movieIds = [Int]()
            for sectionVM in sectionVMs {
                if let rowVMs = sectionVM.rowViewModels?.value as? [SearchMovieRowViewModel] {
                    for rowVM in rowVMs {
                        if let movieId = rowVM.movie?.value?.id {
                            movieIds?.append(movieId)
                        }
                    }
                }
            }
            return movieIds
        }
        return nil
    }
    
}
