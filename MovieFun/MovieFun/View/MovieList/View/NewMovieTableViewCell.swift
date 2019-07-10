//
//  NewMovieTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NewMovieTableViewCell: UITableViewCell, MovieListCell {

    @IBOutlet weak var pagingStackView: UIStackView!
    @IBOutlet weak var newMovieCollectionView: UICollectionView!
    @IBOutlet weak var widthPagingStackView: NSLayoutConstraint!
    
    static let nibName = "NewMovieTableViewCell"
    static let cellIdentify = "newMovieCell"
    
    @IBAction func seeAllAction(_ sender: Any) {
    }
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let newMovieCellVM = viewModel as? NewMovieCellViewModel {
            newMovieCollectionView.register(UINib(nibName: NewMovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: NewMovieCollectionViewCell.cellIdentify)
            newMovieCollectionView.delegate = newMovieCellVM
            newMovieCollectionView.dataSource = newMovieCellVM
            self.setPagingStackView()
        }
    }
    
    private func setPagingStackView() {
        for (_, view) in pagingStackView.arrangedSubviews.enumerated() {
            view.removeFromSuperview()
            pagingStackView.removeArrangedSubview(view)
        }
        let width = pagingStackView.height
        widthPagingStackView.constant = CGFloat(4.0 * width + (4.0 - 1)*5.0)
        for _ in 1...4 {
            let frame = CGRect(x: 0.0, y: 0.0, width: pagingStackView.height, height: width)
            let view = UIView(frame: frame)
            view.layer.cornerRadius = 4.0
            view.clipsToBounds = true
            view.backgroundColor = .gray
            pagingStackView.addArrangedSubview(view)
        }
    }
}
