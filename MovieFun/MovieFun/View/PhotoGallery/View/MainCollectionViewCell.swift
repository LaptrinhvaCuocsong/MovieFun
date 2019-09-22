//
//  MainCollectionViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let nibName = "MainCollectionViewCell"
    static let cellIdentify = "mainCollectionViewCell"
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
    }
    
    func setUp(with viewModel: MainRowViewModel) {
        if let imageName = viewModel.imageName, let accountId = viewModel.accountId {
            if let image = CacheService.share.getObject(key: "\(accountId)/\(imageName)" as NSString) {
                imageView.image = image
            }
            else {
                imageView.addSpinnerView()
                imageView.image = nil
                let subImageView = UIImageView()
                subImageView.backgroundColor = .clear
                imageView.addSubview(subImageView)
                subImageView.fillSuperView()
                StorageService.share.downloadImage(accountId: accountId, imageName: imageName) {[weak self] (data, error) in
                    if error == nil && data != nil {
                        let image = UIImage(data: data!)
                        subImageView.image = image
                        self?.imageView.removeSpinnerView()
                        CacheService.share.setObject(key: "\(accountId)/\(imageName)" as NSString, image: image!)
                    }
                }
            }
        }
    }

}
