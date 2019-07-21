//
//  NewMovieListTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NewMovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var adultImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    static let nibName = "NewMovieListTableViewCell"
    static let cellIdentify = "newMovieListTableViewCell"
    var newMovieListRowVM: NewMovieListRowViewModel?
    
    func setUp(with viewModel: NewMovieListRowViewModel) {
        newMovieListRowVM = viewModel
        setContent()
    }
    
    private func setContent() {
        if let viewModel = newMovieListRowVM, let movie = viewModel.movie?.value {
            titleLabel.text = movie.title
            releaseDateLabel.text = Utils.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: movie.releaseDate)
            ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
            overviewLabel.text = movie.overview
            adultImage.isHidden = !(movie.adult ?? true)
            if let posterPath = movie.posterPath {
                movieImage.setImage(imageName: posterPath, imageSize: .original)
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func selectFavoriteMovie(_ sender: Any) {
    }
    
}
