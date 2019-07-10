//
//  ComingSoonMovieTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NowMovieTableViewCell: UITableViewCell, MovieListCell {
    
    @IBOutlet weak var nowMovieStackView: UIStackView!
    
    static let nibName = "NowMovieTableViewCell"
    static let cellIdentify = "nowMovieCell"
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let nowMovieVM = viewModel as? NowMovieCellViewModel {
            let movies = nowMovieVM.nowMovies!.value![0..<3]
            self.setNowMovieStackView(nowMovies: Array(movies))
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func seeAll(_ sender: UIButton) {
    }
    
    //MARK: - Private method
    
    private func setNowMovieStackView(nowMovies: [Movie]) {
        for (_, view) in nowMovieStackView.subviews.enumerated() {
            view.removeFromSuperview()
            nowMovieStackView.removeArrangedSubview(view)
        }
        for (_, movie) in nowMovies.enumerated() {
            let nowMovieView = NowMovieView.createNowMovieView()
            nowMovieView.setContent(title: movie.title, rage: movie.voteAverage, releaseDate: movie.releaseDate, overview: movie.overview, posterPath: movie.posterPath)
            nowMovieStackView.addArrangedSubview(nowMovieView)
        }
    }
    
}
