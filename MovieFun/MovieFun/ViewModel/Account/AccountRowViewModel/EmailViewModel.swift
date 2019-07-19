//
//  EmailViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol EmailViewModelDelegate: class {
    
    func present(viewController: UIViewController, animated: Bool)
    
}

class EmailViewModel: AccountRowViewModel {
    
    weak var delegate: EmailViewModelDelegate?
    var email: DynamicType<String>?
    
    init() {
        email = DynamicType<String>(value: "")
    }
    
}
