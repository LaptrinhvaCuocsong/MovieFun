//
//  UIImageView+MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/15/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let IMAGE_URL = "https://image.tmdb.org/t/p/%@/%@"

class SpinnerView: UIView {
    
}

extension UIImageView {
    
    var myImage: UIImage? {
        get {
            return self.image
        }
        set {
            if newValue == nil {
                addSpinnerView()
            }
            else {
                removeSpinnerView()
            }
            self.image = newValue
        }
    }
    
    func setImage(imageName: String, imageSize: ImageSize) {
        let urlStr = String(format: IMAGE_URL, imageSize.rawValue, imageName)
        let url = URL(string: urlStr)
        self.sd_setImage(with: url) {[weak self] (image, error, _, _) in
            if error == nil {
                self?.myImage = image
            }
        }
    }
    
}
