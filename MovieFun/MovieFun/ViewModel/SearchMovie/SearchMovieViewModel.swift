//
//  SearchMovieViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/31/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol SearchMovieViewModelDelegate: class {
    
    func presentSpinner()
    
    func dismissSpinner()
    
}

class SearchMovieViewModel {
 
    var searchText: String?
    var totalPage = 0
    var currentPage: DynamicType<Int>?
    var url: String?
    var isFetching: DynamicType<Bool>?
    var isLoadMore: DynamicType<Bool>?
    var sectionViewModels: DynamicType<[SearchMovieSectionViewModel]>?
    weak var delegate: SearchMovieViewModelDelegate?
    
    init() {
        isLoadMore = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        currentPage = DynamicType<Int>(value: 0)
        url = MovieService.NEW_MOVIE_URL
        sectionViewModels = DynamicType<[SearchMovieSectionViewModel]>(value: [SearchMovieSectionViewModel]())
    }
    
}

extension SearchMovieViewModel: SearchMovieRowViewModelDelegate {
    
    func presentSpinner() {
        delegate?.presentSpinner()
    }
    
    func dismissSpinner() {
        delegate?.dismissSpinner()
    }
    
}
