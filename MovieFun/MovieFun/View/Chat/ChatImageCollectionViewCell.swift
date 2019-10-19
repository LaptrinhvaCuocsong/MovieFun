//
//  ChatImageCollectionViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import Photos

protocol ChatImageCollectionViewCellDelegate: class {
    
    func sendImage(asset: PHAsset)
    
}

class ChatImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonSend: UIButton!
    
    static let nibName = "ChatImageCollectionViewCell"
    static let cellIdentify = "chatImageCollectionViewCell"
    private var assetWrapper: PHAssetWrapper?
    weak var delegate: ChatImageCollectionViewCellDelegate?
    
    func setContent(assetWrapper: PHAssetWrapper, imageManager: PHCachingImageManager, imageRequestOption: PHImageRequestOptions?, targetSizeImage: CGSize) {
        self.assetWrapper = assetWrapper
        initBinding()
        for subView in imageView.subviews {
            subView.removeSpinnerView()
        }
        imageView.image = nil
        if let asset = assetWrapper.phAsset {
            imageManager.requestImage(for: asset, targetSize: targetSizeImage, contentMode: .default, options: imageRequestOption) {[weak self] (image, _) in
                self?.imageView.image = image
            }
        }
        if assetWrapper.isSelectedAsset?.value ?? false {
            displayButtonSend()
        }
        else {
            hideButtonSend()
        }
    }
    
    func displayButtonSend() {
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = CGRect(x: imageView.frame.midX, y: imageView.frame.midY, width: 64.0, height: 64.0)
        imageView.addSubview(effectView)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            effectView.fillSuperView()
            self.layoutIfNeeded()
        }, completion: nil)
        buttonSend.isHidden = false
    }
    
    func hideButtonSend() {
        for subView in imageView.subviews {
            subView.removeFromSuperview()
        }
        buttonSend.isHidden = true
    }
    
    @IBAction func sendImage(_ sender: Any) {
        if let asset = assetWrapper?.phAsset {
            delegate?.sendImage(asset: asset)
        }
    }
    
    private func initBinding() {
        assetWrapper?.isSelectedAsset?.listener = {[weak self] (isSelectedAsset) in
            if isSelectedAsset {
                self?.displayButtonSend()
            }
            else {
                self?.hideButtonSend()
            }
        }
    }
    
}
