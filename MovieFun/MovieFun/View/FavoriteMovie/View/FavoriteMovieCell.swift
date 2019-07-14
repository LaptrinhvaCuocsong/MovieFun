//
//  FavoriteMovieCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol FavoriteMovieCell {
    
    func setUp(with viewModel: FavoriteRowViewModel)
    
    func setContent(with movie: Movie)
    
}
