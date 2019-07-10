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
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let trailerVM = viewModel as? TrailersMovieCellViewModel {
            trailerCollectionView.delegate = trailerVM
            trailerCollectionView.dataSource = trailerVM
            trailerCollectionView.register(UINib(nibName: TrailerCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: TrailerCollectionViewCell.cellIdentify)
            setPagingStackView()
            setTrailerStackView(movies: [Movie](trailerVM.trailerMovies!.value![0..<4]))
        }
    }
    
    private func setPagingStackView() {
        for (_, view) in pagingStackView.arrangedSubviews.enumerated() {
            view.removeFromSuperview()
            pagingStackView.removeArrangedSubview(view)
        }
        let width = pagingStackView.height
        let size = 6.0
        widthPagingStackView.constant = CGFloat(size * width + (size - 1)*5.0)
        for _ in 1...Int(size) {
            let frame = CGRect(x: 0.0, y: 0.0, width: pagingStackView.height, height: width)
            let view = UIView(frame: frame)
            view.layer.cornerRadius = 4.0
            view.clipsToBounds = true
            view.backgroundColor = .gray
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
            trailerMovieView.setContent(title: movie.title, posterPath: movie.posterPath)
            trailerStackView.addArrangedSubview(trailerMovieView)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func seeAll(_ sender: Any) {
    }
}
