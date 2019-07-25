//
//  TopRateListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class TopRateListController: ListController {
    
    override init() {
        super.init()
        listViewModel = TopRateListViewModel()
    }
    
    override func start() {
        self.listViewModel?.isFetching?.value = true
        MovieService.share.fetchTopRateMovie(page: 1, language: .en_US) {[weak self] (totalPages, movies) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.buildViewModel(totalPages: totalPages, movies: movies)
            strongSelf.listViewModel?.isFetching?.value = false
            strongSelf.listViewModel?.currentPage?.value = 2
        }
    }
    
    override func pullToRefresh(_ dispatchTime: DispatchTime) {
        self.listViewModel?.isPullToRefresh?.value = true
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            MovieService.share.fetchTopRateMovie(page: 1, language: .en_US) { (totalPages, movies) in
                strongSelf.buildViewModel(totalPages: totalPages, movies: movies)
                strongSelf.listViewModel?.isPullToRefresh?.value = false
                strongSelf.listViewModel?.currentPage?.value = 2
            }
        }
    }
    
    override func loadMore(_ dispatchTime: DispatchTime) {
        self.listViewModel?.isLoadMore?.value = true
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            MovieService.share.fetchTopRateMovie(page: strongSelf.listViewModel!.currentPage!.value!, language: .en_US) { (totalPages, movies) in
                strongSelf.buildViewModelAfterLoadMore(totalPages: totalPages, movies: movies)
                strongSelf.listViewModel?.isLoadMore?.value = false
                let currentPage = strongSelf.listViewModel!.currentPage!.value!
                strongSelf.listViewModel?.currentPage?.value = currentPage + 1
            }
        }
    }
    
    override func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.listSectionViewModels?.value?.removeAll()
            listViewModel?.totalPage = totalPages
            let topRateSectionVM = TopRateListSectionViewModel()
            listViewModel!.listSectionViewModels?.value?.append(topRateSectionVM)
            for (_, movie) in movies.enumerated() {
                let topRateListRowVM = TopRateListRowViewModel()
                topRateListRowVM.movie = DynamicType<Movie>(value: movie)
                topRateSectionVM.listRowViewModels?.value?.append(topRateListRowVM)
            }
        }
    }
    
    override func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.totalPage = totalPages
            let topRateSectionVM = listViewModel!.listSectionViewModels!.value![0]
            for (_, movie) in movies.enumerated() {
                let topRateListRowVM = TopRateListRowViewModel()
                topRateListRowVM.movie = DynamicType<Movie>(value: movie)
                topRateSectionVM.listRowViewModels?.value?.append(topRateListRowVM)
            }
        }
    }
    
}
