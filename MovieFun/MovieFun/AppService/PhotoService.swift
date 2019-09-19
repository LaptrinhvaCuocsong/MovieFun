//
//  PhotoService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/16/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import Photos
import UIKit

class PhotoService {
    
    static let share = PhotoService()
    
    private let imageManager: PHImageManager
    private let imageReqOption: PHImageRequestOptions
    
    private init() {
        imageManager = PHImageManager.default()
        imageReqOption = PHImageRequestOptions()
        imageReqOption.deliveryMode = .highQualityFormat
        imageReqOption.isNetworkAccessAllowed = false
    }
    
    func fetchImage(phAsset: PHAsset, targetSize: CGSize?, completion: ((UIImage?) -> Void)?) {
        let completion:((UIImage?) -> Void) = completion ?? {_ in}
        let targetSize = targetSize ?? CGSize(width: 200.0, height: 300.0)
        imageManager.requestImage(for: phAsset, targetSize: targetSize, contentMode: .default, options: imageReqOption) { (image, _) in
            completion(image)
        }
    }
    
}
