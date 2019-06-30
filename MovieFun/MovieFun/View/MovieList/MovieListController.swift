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
    
    init(viewModel: MovieListViewModel) {
        movieListViewModel = viewModel
    }
    
    func start() {
        movieListViewModel!.isLoading!.value = true
        movieListViewModel!.isHiddenMovieTableView!.value = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.movieListViewModel!.isLoading!.value = false
            strongSelf.movieListViewModel!.isHiddenMovieTableView!.value = false
            strongSelf.buildViewModels()
        }
    }
    
    private func buildViewModels() {
        let newMovieSectionVM = MovieListSectionViewModel()
        let newMovieCellVM = NewMovieCellViewModel()
        newMovieSectionVM.rowViewModels!.value!.append(newMovieCellVM)
        let nowMovieSectionVM = MovieListSectionViewModel()
        let nowMovieCellVM = NowMovieCellViewModel()
        nowMovieSectionVM.rowViewModels!.value!.append(nowMovieCellVM)
        let topRateSectionVM = MovieListSectionViewModel()
        let topRateCellVM = TopRateCellViewModel()
        topRateSectionVM.rowViewModels!.value!.append(topRateCellVM)
        let trailerSectionVM = MovieListSectionViewModel()
        let trailerCellVM = TrailersMovieCellViewModel()
        trailerSectionVM.rowViewModels!.value!.append(trailerCellVM)
        movieListViewModel!.sectionViewModels!.value!.append(newMovieSectionVM)
        movieListViewModel!.sectionViewModels!.value!.append(nowMovieSectionVM)
        movieListViewModel!.sectionViewModels!.value!.append(topRateSectionVM)
        movieListViewModel!.sectionViewModels!.value!.append(trailerSectionVM)
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
