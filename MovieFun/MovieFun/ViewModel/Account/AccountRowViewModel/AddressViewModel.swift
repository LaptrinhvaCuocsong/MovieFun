//
//  AddressViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol AddressViewModelDelegate: class {
    
    func present(viewController: UIViewController, animated: Bool)
    
    func updateAddress(address: String)
    
}

class AddressViewModel: AccountRowViewModel {
    
    weak var delegate: AddressViewModelDelegate?
    var address: DynamicType<String>?
    
    init() {
        address = DynamicType<String>(value: "")
    }
    
}
