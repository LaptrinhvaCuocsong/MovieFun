//
//  PHAssetWrapper.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/15/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import Photos

class PHAssetWrapper {
    
    var phAsset: PHAsset?
    var isSelectedAsset: DynamicType<Bool>?
    
    init(asset: PHAsset) {
        phAsset = asset
        isSelectedAsset = DynamicType<Bool>(value: false)
    }
    
}
