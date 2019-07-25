//
//  NowMovieListTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NowMovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var adultImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    static let nibName = "NowMovieListTableViewCell"
    static let cellIdentify = "nowMovieListTableViewCell"
    var nowMovieListRowVM: NowMovieListRowViewModel?
    
    func setUp(with viewModel: ListRowViewModel) {
        if let viewModel = viewModel as? NowMovieListRowViewModel {
            nowMovieListRowVM = viewModel
            setContent()
        }
    }
    
    private func setContent() {
        if let viewModel = nowMovieListRowVM, let movie = viewModel.movie?.value {
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
