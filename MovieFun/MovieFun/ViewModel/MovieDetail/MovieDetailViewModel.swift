//
//  MovieDetailViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailViewModelDelegate: class {
    
    func pushToViewController(viewController: UIViewController, animated: Bool)
    func commentForMovie(movie: Movie)
    
}

class MovieDetailViewModel {
    
    var isChangeFavorite: DynamicType<Bool>?
    var removeFavoriteSuccess: DynamicType<Bool>?
    var addFavoriteSuccess: DynamicType<Bool>?
    var isLoadFail: DynamicType<Bool>?
    var isFavoriteMovie: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var movieId: DynamicType<String>?
    var movieDetailSectionViewModels: DynamicType<[MovieDetailSectionViewModel]>?
    weak var delegate: MovieDetailViewModelDelegate?
    
    init() {
        isChangeFavorite = DynamicType<Bool>(value: false)
        removeFavoriteSuccess = DynamicType<Bool>(value: false)
        addFavoriteSuccess = DynamicType<Bool>(value: false)
        isLoadFail = DynamicType<Bool>(value: false)
        isFavoriteMovie = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        movieId = DynamicType<String>(value: "")
        movieDetailSectionViewModels = DynamicType<[MovieDetailSectionViewModel]>(value: [MovieDetailSectionViewModel]())
    }
    
}

extension MovieDetailViewModel: MoviePlayerViewModelDelegate, CommentViewModelDelegate {
    
    func pushToViewController(viewController: UIViewController, animated: Bool) {
        self.delegate?.pushToViewController(viewController: viewController, animated: animated)
    }
    
    func commentForMovie(movie: Movie) {
        delegate?.commentForMovie(movie: movie)
    }
    
}
