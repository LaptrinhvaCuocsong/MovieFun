//
//  ComingSoonMovieView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

protocol NowMovieViewDelegate: class {
    
    func push(viewController: UIViewController, animated: Bool)
    
}

class NowMovieView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteRageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    static let nibName = "NowMovieView"
    var movieId: String?
    var tapGesture: UITapGestureRecognizer?
    weak var delegate: NowMovieViewDelegate?
    
    static func createNowMovieView() -> NowMovieView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let nowMovieView = nib.instantiate(withOwner: self, options: nil).first as! NowMovieView
        return nowMovieView
    }
    
    func setContent(movieId: Int?, title: String?, rage: Double?, releaseDate: Date?, overview: String?, posterPath: String?) {
        titleLabel.text = title
        voteRageLabel.text = "\(rage ?? 0.0)"
        releaseDateLabel.text = Utils.share.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: releaseDate)
        overviewLabel.text = overview
        imageView.myImage = nil
        if let posterPath = posterPath {
            imageView.setImage(imageName: posterPath, imageSize: .original)
        }
        if let movieId = movieId {
            self.movieId = "\(movieId)"
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushToMovieDetailViewController))
            self.addGestureRecognizer(tapGesture!)
        }
    }
    
    @objc private func pushToMovieDetailViewController() {
        if let movieId = movieId {
            let movieDetailVC = MovieDetailViewController.createMovieDetailViewController(with: movieId)
            delegate?.push(viewController: movieDetailVC, animated: true)
        }
    }
    
}
