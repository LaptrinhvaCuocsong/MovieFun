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
    var nowMovieVM: NowMovieCellViewModel?
    
    private let HEIGHT_OF_CELL = 160.0
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let viewModel = viewModel as? NowMovieCellViewModel {
            nowMovieVM = viewModel
            let movies = viewModel.nowMovies!.value![0..<3]
            self.setNowMovieStackView(nowMovies: Array(movies))
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func seeAll(_ sender: UIButton) {
        let nowMovieListVC = NowMovieListViewController.createListViewController() as! NowMovieListViewController
        nowMovieVM?.delegate?.push(viewController: nowMovieListVC, animated: true)
    }
    
    //MARK: - Private method
    
    private func setNowMovieStackView(nowMovies: [Movie]) {
        for (_, view) in nowMovieStackView.subviews.enumerated() {
            view.removeFromSuperview()
            nowMovieStackView.removeArrangedSubview(view)
        }
        for (_, movie) in nowMovies.enumerated() {
            let nowMovieView = NowMovieView.createNowMovieView()
            nowMovieView.delegate = self
            nowMovieView.heightAnchor.constraint(equalToConstant: CGFloat(HEIGHT_OF_CELL)).isActive = true
            nowMovieView.setContent(movieId: movie.id, title: movie.title, rage: movie.voteAverage, releaseDate: movie.releaseDate, overview: movie.overview, posterPath: movie.posterPath)
            nowMovieStackView.addArrangedSubview(nowMovieView)
        }
    }
    
}

extension NowMovieTableViewCell: NowMovieViewDelegate {
    
    func push(viewController: UIViewController, animated: Bool) {
        nowMovieVM?.delegate?.push(viewController: viewController, animated: animated)
    }
    
}
