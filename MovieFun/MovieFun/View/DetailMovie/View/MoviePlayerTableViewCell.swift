//
//  MoviePlayerTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class MoviePlayerTableViewCell: UITableViewCell, MovieDetailCell {
    
    @IBOutlet weak var marginTopAppearImage: NSLayoutConstraint!
    @IBOutlet weak var movieImageView: UIImageView!
    
    static let nibName = "MoviePlayerTableViewCell"
    static let cellIdentify = "moviePlayerTableViewCell"
    var moviePlayerVM: MoviePlayerViewModel?
    var animator: UIViewPropertyAnimator?
    
    deinit {
        if let viewModel = moviePlayerVM {
            animator?.stopAnimation(true)
            viewModel.contentOffsetY?.removeListener()
        }
    }
    
    func setUp(with viewModel: MovieDetailRowViewModel) {
        if let viewModel = viewModel as? MoviePlayerViewModel {
            moviePlayerVM = viewModel
            setContent()
            initBinding()
        }
    }
    
    private func setContent() {
        if let viewModel = moviePlayerVM, let movie = viewModel.movie?.value {
            movieImageView.myImage = nil
            if let backdropPath = movie.backdropPath {
                movieImageView.setImage(imageName: backdropPath, imageSize: .original)
            }
            addEffectView()
        }
    }
    
    private func initBinding() {
        if let viewModel = moviePlayerVM {
            viewModel.contentOffsetY?.listener = {[weak self] (contentOffsetY) in
                self?.marginTopAppearImage.constant = CGFloat(contentOffsetY)
                self?.animator?.fractionComplete = CGFloat(abs(-1.0 * contentOffsetY) / 500.0)
            }
        }
    }
    
    private func addEffectView() {
        if let animator = animator {
            animator.stopAnimation(true)
            if let effectView = movieImageView.subviews.last as? UIVisualEffectView {
                effectView.removeFromSuperview()
            }
        }
        animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear, animations: {[weak self] in
            let blurEffect = UIBlurEffect(style: .regular)
            let effectView = UIVisualEffectView(effect: blurEffect)
            self?.movieImageView.addSubview(effectView)
            effectView.fillSuperView()
        })
        animator?.fractionComplete = 0.0
    }
    
    //MARK: - IBAction
    
    @IBAction func playVideo(_ sender: Any) {
        if let moviePlayerVM = moviePlayerVM, let movie = moviePlayerVM.movie?.value, let movieId = movie.id {
            let videoListVC = VideoListViewController.createVideoListViewController(movieId: "\(movieId)")
            moviePlayerVM.delegate?.pushToViewController(viewController: videoListVC, animated: true)
        }
    }
    
}
