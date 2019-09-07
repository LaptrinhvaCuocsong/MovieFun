//
//  FavoriteHeaderTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/24/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class FavoriteHeaderTableViewCell: UITableViewCell, FavoriteCell {

    static let nibName = "FavoriteHeaderTableViewCell"
    static let cellIdentify = "favoriteHeaderTableViewCell"
    var favHeaderVM: FavoriteHeaderRowViewModel?
    
    func setUp(with viewModel: FavoriteBaseRowViewModel) {
        if let viewModel = viewModel as? FavoriteHeaderRowViewModel {
            favHeaderVM = viewModel
        }
    }
    
    @IBAction func addFavoriteMovie(_ sender: Any) {
        favHeaderVM?.delegate?.showSearchMovieViewController()
    }
    
}
