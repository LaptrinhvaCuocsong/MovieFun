//
//  TrailerMovieView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TrailerMovieView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    static let nibName = "TrailerMovieView"
    
    static func createTrailerMovieView() -> TrailerMovieView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let trailerMovieView = nib.instantiate(withOwner: self, options: nil).first as! TrailerMovieView
        return trailerMovieView
    }
    
    func setContent(title: String?, posterPath: String?) {
        titleLabel.text = title
        if let posterPath = posterPath {
            MovieService.share.fetchImage(imageSize: .w185, imageName: posterPath) {[weak self] (image) in
                self?.imageView.image = image
            }
        }
        else {
            imageView.image = UIImage(named: "image-not-found")
        }
    }
    
}
