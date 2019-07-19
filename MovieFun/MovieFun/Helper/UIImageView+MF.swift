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

extension UIImageView {
    
    func setImage(imageName: String, imageSize: ImageSize) {
        let urlStr = String(format: IMAGE_URL, imageSize.rawValue, imageName)
        let url = URL(string: urlStr)
        self.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached, context: nil)
    }
    
}