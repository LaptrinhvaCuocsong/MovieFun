//
//  FavoriteHeaderRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/24/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol FavoriteHeaderRowViewModelDelegate: class {
    
    func showSearchMovieViewController()
    
}

class FavoriteHeaderRowViewModel: FavoriteBaseRowViewModel {
    
    weak var delegate: FavoriteHeaderRowViewModelDelegate?
    
}
