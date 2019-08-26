//
//  FavoriteTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/12/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell, FavoriteCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var adultImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    
    static let nibName = "FavoriteTableViewCell"
    static let cellIdentify = "favoriteTableViewCell"
    var favoriteRowVM: FavoriteRowViewModel?
    
    func setUp(with viewModel: FavoriteBaseRowViewModel) {
        if let viewModel = viewModel as? FavoriteRowViewModel {
            favoriteRowVM = viewModel
            if let movie = viewModel.favoriteMovie?.value {
                setContent(with: movie)
            }
        }
    }
    
    private func setContent(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = Utils.share.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: movie.releaseDate)
        ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
        overviewLabel.text = movie.overview
        adultImage.isHidden = !(movie.adult ?? true)
        starButton.setImage(UIImage(named: "star-64-yellow"), for: .normal)
        posterImage.image = nil
        if let posterPath = movie.posterPath {
            posterImage.setImage(imageName: posterPath, imageSize: .original)
        }
    }
        
    //MARK - IBAction
    
    @IBAction func removeFavoriteMovie(_ sender: Any) {
        starButton.setImage(UIImage(named: "star-64"), for: .normal)
        favoriteRowVM?.removeFavoriteMovie()
    }
}
