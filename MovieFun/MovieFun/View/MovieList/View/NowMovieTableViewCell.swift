//
//  ComingSoonMovieTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NowMovieTableViewCell: UITableViewCell, MovieListCell {
    
    static let nibName = "NowMovieMovieTableViewCell"
    static let cellIdentify = "nowMovieCell"
    
    func setUp(with viewModel: MovieListCellViewModel) {
        guard let nowMovieVM = viewModel as? NowMovieCellViewModel else {
            return
        }
        // setup nowMovieVM
    }
    
}
