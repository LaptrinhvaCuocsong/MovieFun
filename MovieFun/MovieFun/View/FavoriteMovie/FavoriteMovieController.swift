//
//  FavoriteMovieControler.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class FavoriteMovieController {
    
    var favoriteMovieViewModel: FavoriteMovieViewModel?
    
    init() {
        favoriteMovieViewModel = FavoriteMovieViewModel()
    }
    
    func start() {
        favoriteMovieViewModel!.isFetching?.value = true
        FavoriteMovieService.share.fetchFavoriteMovie {[weak self] (movies) in
            self?.buildViewModels(movies: movies)
            self?.favoriteMovieViewModel?.isFetching?.value = false
        }
    }
    
    func search(searchText: String) {
        favoriteMovieViewModel?.isFetching?.value = true
        FavoriteMovieService.share.searchFavoriteMovie(searchText: searchText) {[weak self] (movies) in
            self?.buildViewModels(movies: movies)
            self?.favoriteMovieViewModel?.isFetching?.value = false
        }
    }
    
    func buildViewModels(movies: [Movie]?) {
        if let favoriteMovies = movies {
            favoriteMovieViewModel?.sectionViewModels?.value?.removeAll()
            let favoriteSectionVM = FavoriteSectionViewModel()
            favoriteMovieViewModel!.sectionViewModels!.value!.append(favoriteSectionVM)
            for (_, movie) in favoriteMovies.enumerated() {
                let favoriteRowVM = FavoriteRowViewModel(movie: DynamicType<Movie>(value: movie))
                favoriteRowVM.delegate = favoriteMovieViewModel
                favoriteSectionVM.rowViewModels!.value!.append(favoriteRowVM)
            }
        }
    }
    
}
