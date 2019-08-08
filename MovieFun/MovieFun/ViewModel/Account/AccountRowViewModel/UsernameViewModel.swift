//
//  UsernameViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol UsernameViewModelDelegate: class {
    
    func present(viewController: UIViewController, animated: Bool)
    
    func updateUsername(username: String)
    
}

class UsernameViewModel: AccountRowViewModel {

    weak var delegate: UsernameViewModelDelegate?
    var username: DynamicType<String>?
    
    init() {
        username = DynamicType<String>(value: "")
    }
    
}
