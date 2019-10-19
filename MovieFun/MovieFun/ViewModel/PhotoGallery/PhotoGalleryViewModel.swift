//
//  PhotoGalleryViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoGalleryViewModelDelegate: class {
    
    func showPresentImageViewController(with image: UIImage)
    
}

class PhotoGalleryViewModel {
    
    var isFetching: DynamicType<Bool>?
    var assets: [(accountId: String, imageName: String)]?
    var currentAsset: (accountId: String, imageName: String)?
    var subCollectionViewModel: SubCollectionViewModel?
    var mainCollectionViewModel: MainCollectionViewModel?
    weak var delegate: PhotoGalleryViewModelDelegate?
    
    init() {
        isFetching = DynamicType<Bool>(value: false)
        subCollectionViewModel =  SubCollectionViewModel()
        mainCollectionViewModel = MainCollectionViewModel()
        mainCollectionViewModel?.delegate = self
        initBinding()
    }
    
    private func initBinding() {
        mainCollectionViewModel?.ratioIndex?.listener = {[weak self] ratioIndex in
            self?.subCollectionViewModel?.scrollToPosition(with: ratioIndex)
        }
        subCollectionViewModel?.ratioIndex?.listener = {[weak self] ratioIndex in
            self?.mainCollectionViewModel?.scrollToPosition(with: ratioIndex)
        }
    }
    
}

extension PhotoGalleryViewModel: MainCollectionViewModelDelegate {
    
    func showPresentImageViewController(with image: UIImage) {
        delegate?.showPresentImageViewController(with: image)
    }
    
}
