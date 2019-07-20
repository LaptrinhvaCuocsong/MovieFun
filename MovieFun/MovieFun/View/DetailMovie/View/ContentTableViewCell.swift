//
//  ContentTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell, MovieDetailCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    static let nibName = "ContentTableViewCell"
    static let cellIdentify = "contentTableViewCell"
    var contentVM: ContentViewModel?
    
    func setUp(with viewModel: MovieDetailRowViewModel) {
        if let viewModel = viewModel as? ContentViewModel {
            contentVM = viewModel
            setContent()
        }
    }
    
    private func setContent() {
        if let viewModel = contentVM, let movie = viewModel.movie?.value {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            layoutIfNeeded()
        }
    }
    
}
