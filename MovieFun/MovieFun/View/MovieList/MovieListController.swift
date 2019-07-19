//
//  MovieListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieListController {
    
    var movieListViewModel: MovieListViewModel?
    var movieListService: MovieService?
    
    init(viewModel: MovieListViewModel) {
        movieListViewModel = viewModel
        movieListService = MovieService()
    }
    
    func start() {
        movieListViewModel!.isLoading!.value = true
        movieListViewModel!.isHiddenMovieTableView!.value = true
        movieListService!.fetchMovieList {[weak self] (newMovies, nowMovies, topRateMovies, popularMovies) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.movieListViewModel!.isLoading!.value = false
            strongSelf.movieListViewModel!.isHiddenMovieTableView!.value = false
            strongSelf.buildViewModels(newMovies: newMovies, nowMovies: nowMovies, topRateMovies: topRateMovies, popularMovies: popularMovies)
        }
    }
    
    private func buildViewModels(newMovies: [Movie]?, nowMovies: [Movie]?, topRateMovies: [Movie]?, popularMovies: [Movie]?) {
        var newMovieSectionVM: MovieListSectionViewModel?
        if let newMovies = newMovies {
            newMovieSectionVM = MovieListSectionViewModel()
            let newMovieCellVM = NewMovieCellViewModel(newMovies: DynamicType<[Movie]>(value: newMovies))
            newMovieCellVM.delegate = movieListViewModel
            newMovieSectionVM!.rowViewModels!.value!.append(newMovieCellVM)
            movieListViewModel!.sectionViewModels!.value!.append(newMovieSectionVM!)
        }
        
        var nowMovieSectionVM: MovieListSectionViewModel?
        if let nowMovies = nowMovies {
            nowMovieSectionVM = MovieListSectionViewModel()
            let nowMovieCellVM = NowMovieCellViewModel(nowMovies: DynamicType<[Movie]>(value: nowMovies))
            nowMovieSectionVM!.rowViewModels!.value!.append(nowMovieCellVM)
            movieListViewModel!.sectionViewModels!.value!.append(nowMovieSectionVM!)
        }
        
        var topRateSectionVM: MovieListSectionViewModel?
        if let topRateMovies = topRateMovies {
            topRateSectionVM = MovieListSectionViewModel()
            let topRateCellVM = TopRateCellViewModel(topRateMovies: DynamicType<[Movie]>(value: topRateMovies))
            topRateSectionVM!.rowViewModels!.value!.append(topRateCellVM)
            movieListViewModel!.sectionViewModels!.value!.append(topRateSectionVM!)
        }
        
        var trailerSectionVM: MovieListSectionViewModel?
        if let popularMovies = popularMovies {
            trailerSectionVM = MovieListSectionViewModel()
            let trailerCellVM = TrailersMovieCellViewModel(trailerMovies: DynamicType<[Movie]>(value: popularMovies))
            trailerSectionVM?.rowViewModels!.value!.append(trailerCellVM)
            movieListViewModel!.sectionViewModels!.value!.append(trailerSectionVM!)
        }
    }
    
    func cellIdentify(of viewModel: MovieListCellViewModel) -> String {
        switch viewModel {
        case is NowMovieCellViewModel:
            return NowMovieTableViewCell.cellIdentify
        case is NewMovieCellViewModel:
            return NewMovieTableViewCell.cellIdentify
        case is TopRateCellViewModel:
            return TopRateTableViewCell.cellIdentify
        case is TrailersMovieCellViewModel:
            return TrailersMovieTableViewCell.cellIdentify
        default:
            fatalError("Not Find \(viewModel)")
            break
        }
    }
    
}
