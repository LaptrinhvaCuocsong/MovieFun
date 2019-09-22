//
//  ChatViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol ChatViewModelDelegate: class {
    
    func didTapButtonMessageImageView(asset: (accountId: String, imageName: String))
    
}
class ChatViewModel {
    
    var assets: DynamicType<[(accountId: String, imageName: String)]>?
    var movieId: String?
    var receiveMessageSuccess: DynamicType<Bool>?
    var haveAddMessage: DynamicType<Bool>?
    var isLoadmore: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var sectionViewModels: DynamicType<[ChatSectionViewModel]>?
    var phassets: [PHAssetWrapper]?
    var isFetchingAssets: DynamicType<Bool>?
    weak var delegate: ChatViewModelDelegate?
    
    init() {
        isFetchingAssets = DynamicType<Bool>(value: false)
        receiveMessageSuccess = DynamicType<Bool>(value: false)
        haveAddMessage = DynamicType<Bool>(value: false)
        isLoadmore = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        assets = DynamicType<[(accountId: String, imageName: String)]>(value: [(accountId: String, imageName: String)]())
        sectionViewModels = DynamicType<[ChatSectionViewModel]>(value: [ChatSectionViewModel]())
    }
    
}

extension ChatViewModel: ChatRowViewModelDelegate {
    
    func didTapButtonMessageImageView(asset: (accountId: String, imageName: String)) {
        delegate?.didTapButtonMessageImageView(asset: asset)
    }
    
}
