//
//  ChatRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol ChatRowViewModelDelegate: class {
    
    func didTapButtonMessageImageView(asset: (accountId: String, imageName: String))
    
}

class ChatRowViewModel {

    var previousMessage: Message?
    var currentMessage: Message?
    weak var delegate: ChatRowViewModelDelegate?
    
}
