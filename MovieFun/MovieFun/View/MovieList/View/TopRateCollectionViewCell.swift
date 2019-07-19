//
//  TopRateCollectionViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/9/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TopRateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var heightTitleLable: NSLayoutConstraint!
    
    static let nibName = "TopRateCollectionViewCell"
    static let cellIdentify = "topRateCollectionViewCell"
    
    func setContent(title: String?, overview: String?, backdropPath: String?) {
        titleLabel.text = title
        if titleLabel.intrinsicContentSize.width <= CGFloat(titleLabel.width) {
            heightTitleLable.constant = 17.0
        }
        else {
            heightTitleLable.constant = 34.0
        }
        overviewLabel.text = overview
        if let backdropPath = backdropPath {
            imageView.setImage(imageName: backdropPath, imageSize: .original)
        }
        else {
            imageView.image = UIImage(named: "image-not-found")
        }
    }

}
