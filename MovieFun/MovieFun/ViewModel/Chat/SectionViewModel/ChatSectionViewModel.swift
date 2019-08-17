//
//  ChatSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class ChatSectionViewModel {
    
    var sendDateStr: String?
    var rowViewModels: DynamicType<[ChatRowViewModel]>?
    
    init() {
        rowViewModels = DynamicType<[ChatRowViewModel]>(value: [ChatRowViewModel]())
    }
    
}
