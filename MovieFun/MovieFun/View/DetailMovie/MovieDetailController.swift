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
    
    init() {
        movieDetailViewModel = MovieDetailViewModel()
    }
    
    func start() {
        if let movieId = movieDetailViewModel?.movieId?.value {
            if Utils.validateNumber(string: movieId) {
                movieDetailViewModel?.isFetching?.value = true
                MovieService.share.fetchMovieDetail(movieId: movieId, language: .en_US) {[weak self] (movie, error) in
                    if error == nil {
                        self?.buildViewModel(movie: movie)
                        self?.movieDetailViewModel?.isFetching?.value = false
                    }
                }
            }
        }
    }
    
    private func buildViewModel(movie: Movie?) {
        if let movie = movie {
            let sectionVM = MovieDetailSectionViewModel()
            movieDetailViewModel?.movieDetailSectionViewModels?.value?.append(sectionVM)
            let moviePlayerVM = MoviePlayerViewModel()
            moviePlayerVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.movieDetailRowViewModels?.value?.append(moviePlayerVM)
            let contentVM = ContentViewModel()
            contentVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.movieDetailRowViewModels?.value?.append(contentVM)
            let castVM = CastViewModel()
            castVM.movie = DynamicType<Movie>(value: movie)
            sectionVM.movieDetailRowViewModels?.value?.append(castVM)
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
        default:
            return nil
        }
    }
    
}
