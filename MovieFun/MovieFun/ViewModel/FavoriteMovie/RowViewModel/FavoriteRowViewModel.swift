//
//  FavoriteRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol FavoriteRowViewModelDelegate: class {

    func reloadData()
    
}

class FavoriteRowViewModel: NSObject {
    
    var favoriteMovie: DynamicType<Movie>?
    var isLoading: DynamicType<Bool>?
    weak var delegate: FavoriteRowViewModelDelegate?
    
    init(movie: DynamicType<Movie>) {
        favoriteMovie = movie
        isLoading = DynamicType<Bool>(value: false)
    }
    
    func removeFavoriteMovie() {
        if let movieId = favoriteMovie?.value?.id {
            isLoading?.value = true
            FavoriteMovieService.share.removeFavoriteMovie(movieId: movieId) {[weak self] (deleteSuccess, error) in
                if error == nil && deleteSuccess == nil {
                    self?.delegate?.reloadData()
                }
                self?.isLoading?.value = false
            }
        }
    }
    
}
