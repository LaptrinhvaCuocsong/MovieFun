//
//  TrailerMovieView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

protocol TrailerMovieViewDelegate: class {
    
    func push(viewController: UIViewController, animated: Bool)
    
}

class TrailerMovieView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: TrailerMovieViewDelegate?
    static let nibName = "TrailerMovieView"
    var movieId: Int?
    var tapGesture: UITapGestureRecognizer?
    
    static func createTrailerMovieView() -> TrailerMovieView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let trailerMovieView = nib.instantiate(withOwner: self, options: nil).first as! TrailerMovieView
        return trailerMovieView
    }
    
    func setContent(movieId: Int?, title: String?, posterPath: String?) {
        titleLabel.text = title
        imageView.image = nil
        if let posterPath = posterPath {
            imageView.setImage(imageName: posterPath, imageSize: .original)
        }
        if let movieId = movieId {
            self.movieId = movieId
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushToVideoListViewController))
            self.addGestureRecognizer(tapGesture!)
        }
    }
    
    @objc private func pushToVideoListViewController() {
        if let movieId = movieId {
            let videoListVC = VideoListViewController.createVideoListViewController(movieId: "\(movieId)")
            delegate?.push(viewController: videoListVC, animated: true)
        }
    }
}
