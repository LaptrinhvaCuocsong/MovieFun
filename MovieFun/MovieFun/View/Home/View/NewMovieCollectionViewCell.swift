//
//  NewMovieCollectionViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/6/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import Alamofire

class NewMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let nibName = "NewMovieCollectionViewCell"
    static let cellIdentify = "newMovieCollectionCell"
    let movieService = MovieService()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        imageView.layer.cornerRadius = CGFloat(imageView.width/2)
        imageView.clipsToBounds = true
    }
    
    func setContent(title: String?, voteAverage: Double?, posterPath: String?) {
        titleLabel.text = title
        rageLabel.text = "\(voteAverage ?? 0.0)"
        imageView.myImage = nil
        if let posterPath = posterPath {
            imageView.setImage(imageName: posterPath, imageSize: .original)
        }
    }
    
}
