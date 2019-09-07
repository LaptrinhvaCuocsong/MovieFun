//
//  FavoriteMovieViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol FavoriteMovieViewModelDelegate: class {

    func removeFavoriteMovie()
    
    func showSearchMovieViewController()
    
}

class FavoriteMovieViewModel: NSObject {
    
    var sectionViewModels: DynamicType<[FavoriteSectionViewModel]>?
    var isFetching: DynamicType<Bool>?
    var isLoadFail: DynamicType<Bool>?
    var isHiddenSearchBar: DynamicType<Bool>?
    weak var delegate: FavoriteMovieViewModelDelegate?
    
    override init() {
        sectionViewModels = DynamicType<[FavoriteSectionViewModel]>(value: [FavoriteSectionViewModel]())
        isFetching = DynamicType<Bool>(value: false)
        isLoadFail = DynamicType<Bool>(value: false)
        isHiddenSearchBar = DynamicType<Bool>(value: false)
    }
    
}

extension FavoriteMovieViewModel: FavoriteRowViewModelDelegate, FavoriteHeaderRowViewModelDelegate {
    
    func removeFavoriteMovie() {
        delegate?.removeFavoriteMovie()
    }
    
    func showSearchMovieViewController() {
        delegate?.showSearchMovieViewController()
    }
    
}
