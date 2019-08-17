//
//  ChatRightRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/11/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class ChatRightRowViewModel: ChatRowViewModel {

    var addMessagesSuccess: Bool?
    
    override init() {
        super.init()
        addMessagesSuccess = true
    }
    
    init(addMessageSuccess: Bool) {
        self.addMessagesSuccess = addMessageSuccess
    }
    
}
