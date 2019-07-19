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
        buildViewModel()
    }
    
    private func buildViewModel() {
        //demo
        let sectionVM = MovieDetailSectionViewModel()
        movieDetailViewModel?.movieDetailSectionViewModels?.value?.append(sectionVM)
        let moviePlayerVM = MoviePlayerViewModel()
        sectionVM.movieDetailRowViewModels?.value?.append(moviePlayerVM)
        let contentVM = ContentViewModel()
        sectionVM.movieDetailRowViewModels?.value?.append(contentVM)
        let castVM = CastViewModel()
        sectionVM.movieDetailRowViewModels?.value?.append(castVM)
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
