//
//  ChatRightRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/11/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import Photos

class ChatRightRowViewModel: ChatRowViewModel {

    var addMessagesSuccess: DynamicType<Bool>?
    var phAsset: PHAsset?
    
    override init() {
        super.init()
        addMessagesSuccess = DynamicType<Bool>(value: true)
    }
    
    init(addMessageSuccess: Bool) {
        self.addMessagesSuccess = DynamicType<Bool>(value: addMessageSuccess)
    }
    
}
