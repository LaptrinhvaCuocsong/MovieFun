//
//  MoviePlayerTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class MoviePlayerTableViewCell: UITableViewCell, MovieDetailCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    static let nibName = "MoviePlayerTableViewCell"
    static let cellIdentify = "moviePlayerTableViewCell"
    var moviePlayerVM: MoviePlayerViewModel?
    
    func setUp(with viewModel: MovieDetailRowViewModel) {
        if let viewModel = viewModel as? MoviePlayerViewModel {
            moviePlayerVM = viewModel
            setContent()
        }
    }
    
    private func setContent() {
        if let viewModel = moviePlayerVM, let movie = viewModel.movie?.value {
            movieImageView.image = nil
            if let backdropPath = movie.backdropPath {
                movieImageView.setImage(imageName: backdropPath, imageSize: .original)
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func playVideo(_ sender: Any) {
        if let moviePlayerVM = moviePlayerVM, let movie = moviePlayerVM.movie?.value, let movieId = movie.id {
            let videoListVC = VideoListViewController.createVideoListViewController(movieId: "\(movieId)")
            moviePlayerVM.delegate?.pushToViewController(viewController: videoListVC, animated: true)
        }
    }
    
}
