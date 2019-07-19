//
//  FavoriteTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/12/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell, FavoriteMovieCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var adultImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    
    static let nibName = "FavoriteTableViewCell"
    static let cellIdentify = "favoriteTableViewCell"
    
    func setUp(with viewModel: FavoriteRowViewModel) {
        
    }
    
    func setContent(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = Utils.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: movie.releaseDate)
        ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
        overviewLabel.text = movie.overview
        adultImage.isHidden = !(movie.adult ?? true)
        if let posterPath = movie.posterPath {
            posterImage.setImage(imageName: posterPath, imageSize: .original)
        }
        else {
            posterImage.image = UIImage(named: "image-not-found")
        }
    }
        
    //MARK - IBAction
    
    @IBAction func selectFavoriteMovie(_ sender: Any) {
    }
}
