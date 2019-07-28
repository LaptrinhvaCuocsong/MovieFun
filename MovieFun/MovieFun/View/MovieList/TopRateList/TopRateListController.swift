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
    
    override func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        if let movies = movies, let totalPages = totalPages {
            listViewModel?.listSectionViewModels?.value?.removeAll()
            listViewModel?.totalPage = totalPages
            let topRateSectionVM = TopRateListSectionViewModel()
            listViewModel!.listSectionViewModels?.value?.append(topRateSectionVM)
            for (_, movie) in movies.enumerated() {
                let topRateListRowVM = TopRateListRowViewModel()
                topRateListRowVM.delegate = listViewModel
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
                topRateListRowVM.delegate = listViewModel
                topRateListRowVM.movie = DynamicType<Movie>(value: movie)
                topRateSectionVM.listRowViewModels?.value?.append(topRateListRowVM)
            }
        }
    }
    
}
