//
//  NewMovieTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NewMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var pagingStackView: UIStackView!
    @IBOutlet weak var newMovieCollectionView: UICollectionView!

    static let cellIdentify = "newMovieCell"
    
    @IBAction func seeAllAction(_ sender: Any) {
    }
}
