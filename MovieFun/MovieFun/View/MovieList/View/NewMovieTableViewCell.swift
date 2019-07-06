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

    static let nibName = "NewMovieTableViewCell"
    static let cellIdentify = "newMovieCell"
    
    @IBAction func seeAllAction(_ sender: Any) {
    }
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let newMovieCellVM = viewModel as? NewMovieCellViewModel {
            newMovieCollectionView.delegate = newMovieCellVM
            newMovieCollectionView.dataSource = newMovieCellVM
            self.setPagingStackView(movieSize: newMovieCellVM.newMovies!.value!.count)
        }
    }
    
    private func setPagingStackView(movieSize: Int) {
        let size = movieSize / 4 + 1
        for _ in 1...size {
            let frame = CGRect(x: 0.0, y: 0.0, width: pagingStackView.height, height: pagingStackView.height)
            let view = UIView(frame: frame)
            view.layer.cornerRadius = 10.0
            view.clipsToBounds = true
            view.backgroundColor = .white
            pagingStackView.addArrangedSubview(view)
        }
    }
}
