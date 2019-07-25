//
//  TopRateListTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TopRateListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var adultImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    static let nibName = "TopRateListTableViewCell"
    static let cellIdentify = "topRateListTableViewCell"
    var topRateListRowVM: TopRateListRowViewModel?
    
    func setUp(with viewModel: ListRowViewModel) {
        if let viewModel = viewModel as? TopRateListRowViewModel {
            topRateListRowVM = viewModel
            setContent()
        }
    }
    
    private func setContent() {
        if let viewModel = topRateListRowVM, let movie = viewModel.movie?.value {
            titleLabel.text = movie.title
            releaseDateLabel.text = Utils.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: movie.releaseDate)
            ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
            overviewLabel.text = movie.overview
            adultImage.isHidden = !(movie.adult ?? true)
            movieImage.image = nil
            if let posterPath = movie.posterPath {
                movieImage.setImage(imageName: posterPath, imageSize: .original)
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func selectFavoriteMovie(_ sender: Any) {
    }
    
}
