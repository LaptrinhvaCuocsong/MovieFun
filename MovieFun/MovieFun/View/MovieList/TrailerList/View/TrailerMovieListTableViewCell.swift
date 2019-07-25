//
//  TrailerMovieListTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TrailerMovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trailerImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let nibName = "TrailerMovieListTableViewCell"
    static let cellIdentify = "trailerMovieListTableViewCell"
    var trailerRowVM: TrailerMovieListRowViewModel?
    
    func setUp(with viewModel: ListRowViewModel) {
        if let viewModel = viewModel as? TrailerMovieListRowViewModel {
            trailerRowVM = viewModel
            setContent()
        }
    }
    
    func setContent() {
        if let viewModel = trailerRowVM, let movie = viewModel.movie?.value {
            titleLabel.text = movie.title
            trailerImageView.image = nil
            if let backdropPath = movie.backdropPath {
                trailerImageView.setImage(imageName: backdropPath, imageSize: .original)
            }
        }
    }
    
}
