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
    var newMovieCellVM: NewMovieCellViewModel?
    
    //MARK: - IBAction
    
    @IBAction func seeAllAction(_ sender: Any) {
        let newMovieListVC = NewMovieListViewController.createNewMovieListViewController()
        self.newMovieCellVM?.delegate?.push(viewController: newMovieListVC, animated: true)
    }
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let newMovieCellVM = viewModel as? NewMovieCellViewModel {
            self.newMovieCellVM = newMovieCellVM
            newMovieCollectionView.register(UINib(nibName: NewMovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: NewMovieCollectionViewCell.cellIdentify)
            newMovieCollectionView.delegate = newMovieCellVM
            newMovieCollectionView.dataSource = newMovieCellVM
            self.setPagingStackView(index: 0)
            newMovieCellVM.currentIndex!.listener = {[weak self] index in
                self?.setPagingStackView(index: index)
            }
        }
    }
    
    private func setPagingStackView(index: Int) {
        for (_, view) in pagingStackView.arrangedSubviews.enumerated() {
            view.removeFromSuperview()
            pagingStackView.removeArrangedSubview(view)
        }
        let width = pagingStackView.height
        widthPagingStackView.constant = CGFloat(4.0 * width + (4.0 - 1)*5.0)
        for i in 0...3  {
            let frame = CGRect(x: 0.0, y: 0.0, width: pagingStackView.height, height: width)
            let view = UIView(frame: frame)
            view.layer.cornerRadius = 4.0
            view.clipsToBounds = true
            view.backgroundColor = i == index ? .white : .gray
            pagingStackView.addArrangedSubview(view)
        }
    }
}
