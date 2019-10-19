//
//  MainRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol MainRowViewModelDelegate: class {
    
    func showPresentImageViewController(with image: UIImage)
    
}

class MainRowViewModel {
    
    var imageName: String?
    var accountId: String?
    var isSelectedCell: DynamicType<Bool>?
    weak var delegate: MainRowViewModelDelegate?
    
    init() {
        isSelectedCell = DynamicType<Bool>(value: false)
    }
    
}
