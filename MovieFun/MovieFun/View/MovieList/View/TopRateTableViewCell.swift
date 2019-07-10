//
//  TopRateTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/27/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TopRateTableViewCell: UITableViewCell, MovieListCell {
    
    @IBOutlet weak var topRateCollection: UICollectionView!
    @IBOutlet weak var pagingStackView: UIStackView!
    @IBOutlet weak var widthPaginStackView: NSLayoutConstraint!
    
    static let nibName = "TopRateTableViewCell"
    static let cellIdentify = "topRateCell"
    
    func setUp(with viewModel: MovieListCellViewModel) {
        if let topRateVM = viewModel as? TopRateCellViewModel {
            topRateCollection.delegate = topRateVM
            topRateCollection.dataSource = topRateVM
            topRateCollection.register(UINib(nibName: TopRateCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: TopRateCollectionViewCell.cellIdentify)
            setPagingStackView()
        }
    }
    
    private func setPagingStackView() {
        for (_, view) in pagingStackView.arrangedSubviews.enumerated() {
            view.removeFromSuperview()
            pagingStackView.removeArrangedSubview(view)
        }
        let width = pagingStackView.height
        let size = 6.0
        widthPaginStackView.constant = CGFloat(size * width + (size - 1)*5.0)
        for _ in 1...Int(size) {
            let frame = CGRect(x: 0.0, y: 0.0, width: pagingStackView.height, height: width)
            let view = UIView(frame: frame)
            view.layer.cornerRadius = 4.0
            view.clipsToBounds = true
            view.backgroundColor = .gray
            pagingStackView.addArrangedSubview(view)
        }
    }
    
    //MARK: - IBAction
    @IBAction func seeAll(_ sender: Any) {
    }
    
}
