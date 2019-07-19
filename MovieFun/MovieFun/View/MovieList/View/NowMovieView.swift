//
//  ComingSoonMovieView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NowMovieView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteRageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    static let nibName = "NowMovieView"
    
    static func createNowMovieView() -> NowMovieView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let nowMovieView = nib.instantiate(withOwner: self, options: nil).first as! NowMovieView
        return nowMovieView
    }
    
    func setContent(title: String?, rage: Double?, releaseDate: Date?, overview: String?, posterPath: String?) {
        titleLabel.text = title
        voteRageLabel.text = "\(rage ?? 0.0)"
        releaseDateLabel.text = Utils.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: releaseDate)
        overviewLabel.text = overview
        if let posterPath = posterPath {
            imageView.setImage(imageName: posterPath, imageSize: .original)
        }
        else {
            imageView.image = UIImage(named: "image-not-found")
        }
    }
    
}
