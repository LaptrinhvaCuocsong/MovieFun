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
        
    }
    
    func cellIdentify(of viewModel: MovieListCellViewModel) -> String {
        switch viewModel {
        case is NowMovieCellViewModel:
            return NowMovieMovieTableViewCell.cellIdentify
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
