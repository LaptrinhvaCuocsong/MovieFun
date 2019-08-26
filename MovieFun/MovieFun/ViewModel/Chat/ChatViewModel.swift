//
//  ChatViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class ChatViewModel {
    
    var movieId: String?
    var receiveMessageSuccess: DynamicType<Bool>?
    var haveAddMessage: DynamicType<Bool>?
    var isLoadmore: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var sectionViewModels: DynamicType<[ChatSectionViewModel]>?
    
    init() {
        receiveMessageSuccess = DynamicType<Bool>(value: false)
        haveAddMessage = DynamicType<Bool>(value: false)
        isLoadmore = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        sectionViewModels = DynamicType<[ChatSectionViewModel]>(value: [ChatSectionViewModel]())
    }
    
}
