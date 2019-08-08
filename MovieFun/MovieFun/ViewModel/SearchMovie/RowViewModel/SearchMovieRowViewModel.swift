//
//  SearchMovieRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/31/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol SearchMovieRowViewModelDelegate: class {
    
    func presentSpinner()
    
    func dismissSpinner()
    
}

class SearchMovieRowViewModel {
    
    var movie: DynamicType<Movie>?
    var isFavoriteMovie: DynamicType<Bool>?
    var isLoading: DynamicType<Bool>?
    weak var delegate: SearchMovieRowViewModelDelegate?
    
    init() {
        isLoading = DynamicType<Bool>(value: false)
        isFavoriteMovie = DynamicType<Bool>(value: false)
    }
    
    func selectFavoriteMovie() {
        isLoading?.value = true
        if let isFavoriteMovie = isFavoriteMovie?.value {
            if isFavoriteMovie {
                FavoriteMovieService.share.removeFavoriteMovie(movieId: movie!.value!.id!) {[weak self] (deleteSucces, error) in
                    if error == nil && deleteSucces == true {
                        self?.isFavoriteMovie?.value = !isFavoriteMovie
                    }
                    self?.isLoading?.value = false
                }
            }
            else {
                FavoriteMovieService.share.addFavoriteMovie(movie: movie!.value!) {[weak self] (error) in
                    if error == nil {
                        self?.isFavoriteMovie?.value = !isFavoriteMovie
                    }
                    self?.isLoading?.value = false
                }
            }
        }
    }
    
}
