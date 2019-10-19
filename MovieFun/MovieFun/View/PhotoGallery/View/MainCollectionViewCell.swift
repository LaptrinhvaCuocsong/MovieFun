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
    @IBOutlet weak var zoomInButton: UIButton!
    
    static let nibName = "MainCollectionViewCell"
    static let cellIdentify = "mainCollectionViewCell"
    private var viewModel: MainRowViewModel?
    var image: UIImage?
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
        zoomInButton.layer.cornerRadius = CGFloat(zoomInButton.height) / 2
    }
    
    func setUp(with viewModel: MainRowViewModel) {
        self.viewModel = viewModel
        for imgView in imageView.subviews {
            imgView.removeFromSuperview()
        }
        imageView.image = nil
        if let imageName = viewModel.imageName, let accountId = viewModel.accountId {
            if let image = CacheService.share.getObject(key: "\(accountId)/\(imageName)" as NSString) {
                imageView.image = image
                self.image = image
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
                        self?.image = image
                        subImageView.image = image
                        self?.imageView.removeSpinnerView()
                        CacheService.share.setObject(key: "\(accountId)/\(imageName)" as NSString, image: image!)
                    }
                }
            }
        }
        if viewModel.isSelectedCell?.value ?? false {
            displayZoomInButton()
        }
        else {
            hideZoomInButton()
        }
        initBinding()
    }
    
    private func displayZoomInButton() {
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        imageView.addSubview(effectView)
        effectView.frame = CGRect(x: imageView.frame.midX, y: imageView.frame.midY, width: 64.0, height: 64.0)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            effectView.fillSuperView()
            self.layoutIfNeeded()
        }, completion: nil)
        zoomInButton.isHidden = false
    }
    
    private func hideZoomInButton() {
        for imgView in imageView.subviews {
            imgView.removeFromSuperview()
        }
        zoomInButton.isHidden = true
    }
    
    private func initBinding() {
        guard let viewModel = self.viewModel else {
            return
        }
        viewModel.isSelectedCell?.listener = {[weak self] (isSelected) in
            if isSelected {
                self?.displayZoomInButton()
            }
            else {
                self?.hideZoomInButton()
            }
        }
    }

    @IBAction func zoomInClicked(_ sender: Any) {
        if let image = self.image {
            viewModel?.delegate?.showPresentImageViewController(with: image)
        }
    }
    
}
