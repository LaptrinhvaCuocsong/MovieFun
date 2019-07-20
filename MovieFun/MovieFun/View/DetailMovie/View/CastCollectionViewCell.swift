//
//  CastCollectionViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let nibName = "CastCollectionViewCell"
    static let cellIdentify = "castCollectionViewCell"
    
    func setContent(imageName: String?, castName: String?) {
        nameLabel.text = castName
        if let castImageName = imageName {
            castImageView.setImage(imageName: castImageName, imageSize: .original)
        }
        else {
            castImageView.image = UIImage(named: Constants.IMAGE_NOT_FOUND)
        }
    }
    
}
