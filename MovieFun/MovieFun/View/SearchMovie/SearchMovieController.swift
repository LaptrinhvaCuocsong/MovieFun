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
    
    func start() {
        searchMovieViewModel?.searchText = nil
        searchMovieViewModel?.isFetching?.value = true
        MovieService.share.fetchMovie(url: searchMovieViewModel!.url!, language: .en_US, page: 1) {[weak self] (totalPage, movies, error) in
            if error == nil {
                self?.buildViewModels(movies: movies)
                self?.searchMovieViewModel?.totalPage = totalPage ?? 0
                self?.searchMovieViewModel?.currentPage?.value = 2
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for (i, _) in rowVMs.enumerated() {
                                    rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
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
                self?.searchMovieViewModel?.isFetching?.value = false
            }
        }
    }
    
    func search(searchText: String) {
        searchMovieViewModel?.searchText = searchText
        searchMovieViewModel?.isFetching?.value = true
        MovieService.share.searchMovie(searchText: searchText, page: 1, language: .en_US) {[weak self] (totalPage, movies, error) in
            if error == nil {
                self?.buildViewModels(movies: movies)
                self?.searchMovieViewModel?.totalPage = totalPage ?? 0
                self?.searchMovieViewModel?.currentPage?.value = 2
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for (i, _) in rowVMs.enumerated() {
                                    rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
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
            if error == nil {
                self?.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
                let currentPage = self!.searchMovieViewModel!.currentPage!.value!
                self?.searchMovieViewModel?.currentPage?.value = currentPage + 1
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for (i, _) in rowVMs.enumerated() {
                                    rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
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
                self?.searchMovieViewModel?.isLoadMore?.value = false
            }
        }
    }
    
    private func loadMoreForNewMovie() {
        MovieService.share.fetchMovie(url: searchMovieViewModel!.url!, language: .en_US, page: searchMovieViewModel!.currentPage!.value!, completion: {[weak self] (totalPages, movies, error) in
            if error == nil {
                self?.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
                let currentPage = self!.searchMovieViewModel!.currentPage!.value!
                self?.searchMovieViewModel?.currentPage?.value = currentPage + 1
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for (i, _) in rowVMs.enumerated() {
                                    rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
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
                self?.searchMovieViewModel?.isLoadMore?.value = false
            }
        })
    }
    
    private func buildViewModels(movies: [Movie]?) {
        if let movies = movies {
            searchMovieViewModel?.sectionViewModels?.value?.removeAll()
            let sectionVM = SearchMovieSectionViewModel()
            searchMovieViewModel?.sectionViewModels?.value?.append(sectionVM)
            for movie in movies {
                let rowVM = SearchMovieRowViewModel()
                rowVM.delegate = searchMovieViewModel
                rowVM.movie = DynamicType<Movie>(value: movie)
                sectionVM.rowViewModels?.value?.append(rowVM)
            }
        }
    }
    
    private func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            searchMovieViewModel?.totalPage = totalPages
            let sectionVM = searchMovieViewModel!.sectionViewModels!.value![0]
            for (_, movie) in movies.enumerated() {
                let rowVM = SearchMovieRowViewModel()
                rowVM.delegate = searchMovieViewModel
                rowVM.movie = DynamicType<Movie>(value: movie)
                sectionVM.rowViewModels?.value?.append(rowVM)
            }
        }
    }
    
    private func getRowVMFromListViewModel() -> [SearchMovieRowViewModel]? {
        var rowViewModels: [SearchMovieRowViewModel]?
        if let sectionVMs = self.searchMovieViewModel?.sectionViewModels?.value {
            rowViewModels = [SearchMovieRowViewModel]()
            for sectionVM in sectionVMs {
                if let rowVMs = sectionVM.rowViewModels?.value {
                    rowViewModels?.append(contentsOf: rowVMs)
                }
            }
            return rowViewModels
        }
        return nil
    }
    
    private func getMovieIdsFromListViewModel() -> [Int?]? {
        var movieIds: [Int?]?
        if let sectionVMs = self.searchMovieViewModel?.sectionViewModels?.value {
            movieIds = [Int?]()
            for sectionVM in sectionVMs {
                if let rowVMs = sectionVM.rowViewModels?.value {
                    movieIds?.append(contentsOf: rowVMs.map({ (rowVM) -> Int? in
                        return rowVM.movie?.value?.id
                    }))
                }
            }
            return movieIds
        }
        return nil
    }
    
}
