//
//  MovieDetailController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieDetailController {
    
    var movieDetailViewModel: MovieDetailViewModel?
    var movie: Movie?
    
    init() {
        movieDetailViewModel = MovieDetailViewModel()
    }
    
    func start() {
        if let movieId = movieDetailViewModel?.movieId?.value {
            if Utils.validateNumber(string: movieId) {
                movieDetailViewModel?.isFavoriteMovie?.value = false
                movieDetailViewModel?.isFetching?.value = true
                MovieService.share.fetchMovieDetail(movieId: movieId, language: .en_US) {[weak self] (movie, casts) in
                    self?.buildViewModel(movie: movie, casts: casts)
                    if let movie = movie, let id = movie.id {
                        FavoriteMovieService.share.checkFavoriteMovie(movieId: id, completion: { (isFavorite, error) in
                            if error == nil {
                                self?.movieDetailViewModel?.isFavoriteMovie?.value = isFavorite ?? false
                            }
                            self?.movieDetailViewModel?.isFetching?.value = false
                        })
                        self?.movie = movie
                        self?.movieDetailViewModel?.isLoadFail?.value = false
                    }
                    else {
                        self?.movieDetailViewModel?.isFetching?.value = true
                        self?.movieDetailViewModel?.isLoadFail?.value = true
                    }
                }
            }
            else {
                movieDetailViewModel?.isLoadFail?.value = true
            }
        }
    }
    
    private func buildViewModel(movie: Movie?, casts: [Cast]?) {
        if let movie = movie {
            let sectionVM = MovieDetailSectionViewModel()
            movieDetailViewModel?.movieDetailSectionViewModels?.value?.append(sectionVM)
            let moviePlayerVM = MoviePlayerViewModel()
            moviePlayerVM.delegate = movieDetailViewModel
            moviePlayerVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.movieDetailRowViewModels?.value?.append(moviePlayerVM)
            let contentVM = ContentViewModel()
            contentVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.movieDetailRowViewModels?.value?.append(contentVM)
            if let casts = casts {
                let castVM = CastViewModel()
                castVM.movie = DynamicType<Movie>(value: movie)
                castVM.casts = DynamicType<[Cast]>(value: casts)
                sectionVM.movieDetailRowViewModels?.value?.append(castVM)
            }
            let commentVM = CommentViewModel()
            commentVM.delegate = movieDetailViewModel
            commentVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.movieDetailRowViewModels?.value?.append(commentVM)
        }
    }
    
    func changeFavoriteMovie(_ isFavorite: Bool) {
        if let movie = self.movie, let movieId = movie.id {
            movieDetailViewModel?.isChangeFavorite?.value = true
            if isFavorite {
                FavoriteMovieService.share.addFavoriteMovie(movie: movie) {[weak self] (error) in
                    if error == nil {
                        self?.movieDetailViewModel?.addFavoriteSuccess?.value = true
                    }
                    else {
                        self?.movieDetailViewModel?.addFavoriteSuccess?.value = false
                    }
                    self?.movieDetailViewModel?.isChangeFavorite?.value = false
                }
            }
            else {
                FavoriteMovieService.share.removeFavoriteMovie(movieId: movieId) {[weak self] (deleteSuccess, error) in
                    if error == nil && (deleteSuccess ?? false) {
                        self?.movieDetailViewModel?.removeFavoriteSuccess?.value = true
                    }
                    else {
                        self?.movieDetailViewModel?.removeFavoriteSuccess?.value = false
                    }
                    self?.movieDetailViewModel?.isChangeFavorite?.value = false
                }
            }
        }
        else {
            if isFavorite {
                movieDetailViewModel?.addFavoriteSuccess?.value = false
            }
            else {
                movieDetailViewModel?.removeFavoriteSuccess?.value = false
            }
        }
    }
    
    func cellIdentify(with viewModel: MovieDetailRowViewModel) -> String? {
        switch viewModel {
        case is MoviePlayerViewModel:
            return MoviePlayerTableViewCell.cellIdentify
        case is ContentViewModel:
            return ContentTableViewCell.cellIdentify
        case is CastViewModel:
            return CastTableViewCell.cellIdentify
        case is CommentViewModel:
            return CommentTableViewCell.cellIdentify
        default:
            return nil
        }
    }
    
}
