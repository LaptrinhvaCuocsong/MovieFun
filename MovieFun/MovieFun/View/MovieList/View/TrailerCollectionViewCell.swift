//
//  TrailerCollectionViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TrailerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let nibName = "TrailerCollectionViewCell"
    static let cellIdentify = "trailerCollectionViewCell"
    
    func setContent(title: String?, backdropPath: String?) {
        titleLabel.text = title
        if let backdropPath = backdropPath {
            MovieService.share.fetchImage(imageSize: .original, imageName: backdropPath) {[weak self] (image) in
                self?.imageView.image = image
            }
        }
    }
}
