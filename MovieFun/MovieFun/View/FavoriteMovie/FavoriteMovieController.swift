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
            if let favoriteMovies = movies {
                self?.buildViewModels(favoriteMovies: favoriteMovies)
            }
            else {
                self?.favoriteMovieViewModel?.isLoadFail?.value = true
            }
            self?.favoriteMovieViewModel?.isFetching?.value = false
        }
    }
    
    func search(searchText: String) {
        favoriteMovieViewModel?.isFetching?.value = true
        FavoriteMovieService.share.searchFavoriteMovie(searchText: searchText) {[weak self] (movies) in
            if let favoriteMovies = movies {
                self?.buildViewModelsForSearch(favoriteMovies: favoriteMovies)
            }
            else {
                self?.favoriteMovieViewModel?.isLoadFail?.value = true
            }
            self?.favoriteMovieViewModel?.isFetching?.value = false
        }
    }
    
    func buildViewModels(favoriteMovies: [Movie]) {
        favoriteMovieViewModel?.isHiddenSearchBar?.value = false
        favoriteMovieViewModel?.sectionViewModels?.value?.removeAll()
        let favoriteSectionVM = FavoriteSectionViewModel()
        favoriteMovieViewModel!.sectionViewModels!.value!.append(favoriteSectionVM)
        for (_, movie) in favoriteMovies.enumerated() {
            let favoriteRowVM = FavoriteRowViewModel(movie: DynamicType<Movie>(value: movie))
            favoriteRowVM.delegate = favoriteMovieViewModel
            favoriteSectionVM.rowViewModels!.value!.append(favoriteRowVM)
        }
        if favoriteMovies.count == 0 {
            favoriteMovieViewModel?.isHiddenSearchBar?.value = true
            let favoriteHeaderRowVM = FavoriteHeaderRowViewModel()
            favoriteSectionVM.rowViewModels?.value?.append(favoriteHeaderRowVM)
        }
    }
    
    func buildViewModelsForSearch(favoriteMovies: [Movie]) {
        favoriteMovieViewModel?.sectionViewModels?.value?.removeAll()
        let favoriteSectionVM = FavoriteSectionViewModel()
        favoriteMovieViewModel!.sectionViewModels!.value!.append(favoriteSectionVM)
        for (_, movie) in favoriteMovies.enumerated() {
            let favoriteRowVM = FavoriteRowViewModel(movie: DynamicType<Movie>(value: movie))
            favoriteRowVM.delegate = favoriteMovieViewModel
            favoriteSectionVM.rowViewModels!.value!.append(favoriteRowVM)
        }
        if favoriteMovies.count == 0 {
            
        }
    }
    
    func cellIdentify(rowVM: FavoriteBaseRowViewModel) -> String? {
        switch rowVM {
        case is FavoriteRowViewModel:
            return FavoriteTableViewCell.cellIdentify
        case is FavoriteHeaderRowViewModel:
            return FavoriteHeaderTableViewCell.cellIdentify
        default:
            return nil
        }
    }
    
}
