//
//  TrailersMovieTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TrailersMovieTableViewCell: UITableViewCell, MovieListCell {
    
    @IBOutlet weak var pagingStackView: UIStackView!
    @IBOutlet weak var trailerCollectionView: UICollectionView!
    @IBOutlet weak var trailerStackView: UIStackView!
    @IBOutlet weak var widthPagingStackView: NSLayoutConstraint!
    
    static let nibName = "TrailersMovieTableViewCell"
    static let cellIdentify = "trailerMovieCell"
    var trailerMV: TrailersMovieCellViewModel?
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let trailerVM = viewModel as? TrailersMovieCellViewModel {
            self.trailerMV = trailerVM
            trailerCollectionView.delegate = trailerVM
            trailerCollectionView.dataSource = trailerVM
            trailerCollectionView.register(UINib(nibName: TrailerCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: TrailerCollectionViewCell.cellIdentify)
            setPagingStackView(index: 0)
            trailerVM.currentIndex!.listener = {[weak self] index in
                self?.setPagingStackView(index: index)
            }
            setTrailerStackView(movies: [Movie](trailerVM.trailerMovies!.value![6..<10]))
        }
    }
    
    private func setPagingStackView(index: Int) {
        for (_, view) in pagingStackView.arrangedSubviews.enumerated() {
            view.removeFromSuperview()
            pagingStackView.removeArrangedSubview(view)
        }
        let width = pagingStackView.height
        let size = 6.0
        widthPagingStackView.constant = CGFloat(size * width + (size - 1)*5.0)
        for i in 0..<Int(size) {
            let frame = CGRect(x: 0.0, y: 0.0, width: pagingStackView.height, height: width)
            let view = UIView(frame: frame)
            view.layer.cornerRadius = 4.0
            view.clipsToBounds = true
            view.backgroundColor = i == index ? .white : .gray
            pagingStackView.addArrangedSubview(view)
        }
    }
    
    private func setTrailerStackView(movies: [Movie]) {
        for (_, view) in trailerStackView.subviews.enumerated() {
            view.removeFromSuperview()
            trailerStackView.removeArrangedSubview(view)
        }
        for (_, movie) in movies.enumerated() {
            let trailerMovieView = TrailerMovieView.createTrailerMovieView()
            trailerMovieView.delegate = self
            trailerMovieView.setContent(movieId: movie.id, title: movie.title, posterPath: movie.posterPath)
            trailerStackView.addArrangedSubview(trailerMovieView)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func seeAll(_ sender: Any) {
        let trailerListVC = TrailerListViewController.createListViewController()
        trailerMV?.delegate?.push(viewController: trailerListVC, animated: true)
    }
}

extension TrailersMovieTableViewCell: TrailerMovieViewDelegate {
    
    func push(viewController: UIViewController, animated: Bool) {
        self.trailerMV?.delegate?.push(viewController: viewController, animated: animated)
    }
    
}
