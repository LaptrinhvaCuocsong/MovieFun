//
//  ListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/23/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class ListController {
    
    var listViewModel: ListViewModel?
    
    init() {
        listViewModel = ListViewModel()
    }
    
    func start() {
        self.listViewModel?.isFetching?.value = true
        MovieService.share.fetchMovie(url: self.listViewModel!.url!, language: .en_US, page: 1) {[weak self] (totalPages, movies, error) in
            guard let strongSelf = self else {
                return
            }
            if error == nil {
                strongSelf.buildViewModel(totalPages: totalPages, movies: movies)
                strongSelf.listViewModel?.currentPage?.value = 2
                if let rowVMs = self?.getRowVMFromListViewModel() {
                    FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                        if error == nil {
                            if let isFavoriteMovies = isFavoriteMovies {
                                for (i, _) in rowVMs.enumerated() {
                                    rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
                                }
                            }
                        }
                        strongSelf.listViewModel?.isFetching?.value = false
                    })
                }
                else {
                    strongSelf.listViewModel?.isFetching?.value = false
                }
            }
            else {
                strongSelf.listViewModel?.isFetching?.value = false
            }
        }
    }
    
    func pullToRefresh(_ dispatchTime: DispatchTime) {
        self.listViewModel?.isPullToRefresh?.value = true
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            MovieService.share.fetchMovie(url: strongSelf.listViewModel!.url!, language: .en_US, page: 1, completion: { (totalPages, movies, error) in
                if error == nil {
                    strongSelf.buildViewModel(totalPages: totalPages, movies: movies)
                    strongSelf.listViewModel?.currentPage?.value = 2
                    if let rowVMs = self?.getRowVMFromListViewModel() {
                        FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                            if error == nil {
                                if let isFavoriteMovies = isFavoriteMovies {
                                    for (i, _) in rowVMs.enumerated() {
                                        rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
                                    }
                                }
                            }
                            strongSelf.listViewModel?.isPullToRefresh?.value = false
                        })
                    }
                    else {
                        strongSelf.listViewModel?.isPullToRefresh?.value = false
                    }
                }
                else {
                    strongSelf.listViewModel?.isPullToRefresh?.value = false
                }
            })
        }
    }
    
    func loadMore(_ dispatchTime: DispatchTime) {
        self.listViewModel?.isLoadMore?.value = true
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            MovieService.share.fetchMovie(url: strongSelf.listViewModel!.url!, language: .en_US, page: strongSelf.listViewModel!.currentPage!.value!, completion: { (totalPages, movies, error) in
                if error == nil {
                    strongSelf.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
                    let currentPage = strongSelf.listViewModel!.currentPage!.value!
                    strongSelf.listViewModel?.currentPage?.value = currentPage + 1
                    if let rowVMs = self?.getRowVMFromListViewModel() {
                        FavoriteMovieService.share.checkFavoriteMovie(movieIds: self?.getMovieIdsFromListViewModel(), completion: { (isFavoriteMovies, error) in
                            if error == nil {
                                if let isFavoriteMovies = isFavoriteMovies {
                                    for (i, _) in rowVMs.enumerated() {
                                        rowVMs[i].isFavoriteMovie?.value = isFavoriteMovies[i] ?? false
                                    }
                                }
                            }
                            strongSelf.listViewModel?.isLoadMore?.value = false
                        })
                    }
                    else {
                        strongSelf.listViewModel?.isLoadMore?.value = false
                    }
                }
                else {
                    strongSelf.listViewModel?.isLoadMore?.value = false
                }
            })
        }
    }
    
    func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        //Implement at child class
    }
    
    func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        //Implement at child class
    }
    
    func getRowVMFromListViewModel() -> [ListRowViewModel]? {
        var rowViewModels: [ListRowViewModel]?
        if let sectionVMs = self.listViewModel?.listSectionViewModels?.value {
            rowViewModels = [ListRowViewModel]()
            for sectionVM in sectionVMs {
                if let rowVMs = sectionVM.listRowViewModels?.value {
                    rowViewModels?.append(contentsOf: rowVMs)
                }
            }
            return rowViewModels
        }
        return nil
    }
    
    func getMovieIdsFromListViewModel() -> [Int?]? {
        var movieIds: [Int?]?
        if let sectionVMs = self.listViewModel?.listSectionViewModels?.value {
            movieIds = [Int?]()
            for sectionVM in sectionVMs {
                if let rowVMs = sectionVM.listRowViewModels?.value {
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
