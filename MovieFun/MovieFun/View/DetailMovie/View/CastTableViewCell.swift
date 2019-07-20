//
//  CastTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class CastTableViewCell: UITableViewCell, MovieDetailCell {
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    static let nibName = "CastTableViewCell"
    static let cellIdentify = "castTableViewCell"
    var castVM: CastViewModel?
    
    func setUp(with viewModel: MovieDetailRowViewModel) {
        if let viewModel = viewModel as? CastViewModel {
            castVM = viewModel
            setContent()
        }
    }
    
    func setContent() {
        if let castVM = castVM, let movie = castVM.movie?.value {
            
        }
    }
    
}
