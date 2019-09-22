//
//  PhotoGalleryController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class PhotoGalleryController {
    
    var photoGalleryVM: PhotoGalleryViewModel?
    
    init() {
        photoGalleryVM = PhotoGalleryViewModel()
    }
    
    func start() {
        photoGalleryVM?.isFetching?.value = true
        if let assets = photoGalleryVM?.assets, let currentAsset = photoGalleryVM?.currentAsset {
            let index = assets.firstIndex { (arg) -> Bool in
                return arg.accountId == currentAsset.accountId && arg.imageName == currentAsset.imageName
            } ?? 0
            buildViewModels(assets: assets, currentAssetIndex: index)
            photoGalleryVM?.isFetching?.value = false
        }
    }
    
    func buildViewModels(assets: [(accountId: String, imageName: String)], currentAssetIndex: Int) {
        // build main collection view model
        photoGalleryVM?.mainCollectionViewModel?.currentAssetIndex = currentAssetIndex
        let mainSectionVM = MainSectionViewModel()
        photoGalleryVM?.mainCollectionViewModel?.mainSectionViewModels?.value?.append(mainSectionVM)
        for asset in assets {
            let mainRowVM = MainRowViewModel()
            mainRowVM.accountId = asset.accountId
            mainRowVM.imageName = asset.imageName
            mainSectionVM.mainRowViewModels?.value?.append(mainRowVM)
        }
        // build sub collection view model
        photoGalleryVM?.subCollectionViewModel?.currentAssetIndex = currentAssetIndex
        let subSectionVM = SubSectionViewModel()
        photoGalleryVM?.subCollectionViewModel?.subSectionViewModel?.value?.append(subSectionVM)
        for asset in assets {
            let subRowVM = SubRowViewModel()
            subRowVM.imageName = asset.imageName
            subRowVM.accountId = asset.accountId
            subSectionVM.subRowViewModels?.value?.append(subRowVM)
        }
    }
    
}
