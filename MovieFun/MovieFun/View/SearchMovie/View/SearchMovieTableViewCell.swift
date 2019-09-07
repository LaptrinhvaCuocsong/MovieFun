//
//  SearchMovieTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/31/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell, SearchCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var adultImage: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    static let nibName = "SearchMovieTableViewCell"
    static let cellIdentify = "searchMovieTableViewCell"
    var searchMovieRowVM: SearchMovieRowViewModel?
    
    func setUp(with viewModel: SearchMovieBaseRowViewModel) {
        if let searchMovieRowVM = viewModel as? SearchMovieRowViewModel {
            self.searchMovieRowVM = searchMovieRowVM
            setContent()
        }
    }
    
    func setContent() {
        if let viewModel = searchMovieRowVM, let movie = viewModel.movie?.value {
            titleLabel.text = movie.title
            releaseDateLabel.text = Utils.share.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: movie.releaseDate)
            ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
            overviewLabel.text = movie.overview
            adultImage.isHidden = !(movie.adult ?? true)
            movieImage.myImage = nil
            if let posterPath = movie.posterPath {
                movieImage.setImage(imageName: posterPath, imageSize: .original)
            }
            if let isFavoriteMovie = viewModel.isFavoriteMovie?.value {
                if isFavoriteMovie {
                    starButton.setImage(UIImage(named: "star-64-yellow"), for: .normal)
                }
                else {
                    starButton.setImage(UIImage(named: "star-64"), for: .normal)
                }
            }
            initBinding()
        }
    }
    
    private func initBinding() {
        if let viewModel = searchMovieRowVM {
            viewModel.isLoading?.listener = {(isLoading) in
                if !isLoading {
                    viewModel.delegate?.dismissSpinner()
                }
                else {
                    viewModel.delegate?.presentSpinner()
                }
            }
            viewModel.isFavoriteMovie?.listener = {[weak self] (isFavoriteMovie) in
                if isFavoriteMovie {
                    self?.starButton.setImage(UIImage(named: "star-64-yellow"), for: .normal)
                }
                else {
                    self?.starButton.setImage(UIImage(named: "star-64"), for: .normal)
                }
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func selectFavoriteMovie(_ sender: Any) {
        searchMovieRowVM?.selectFavoriteMovie()
    }
    
}