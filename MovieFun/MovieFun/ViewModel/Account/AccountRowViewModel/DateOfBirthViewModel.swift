//
//  DateOfBirthViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol DateOfBirthViewModelDelegate: class {
    
    func present(viewController: UIViewController, animated: Bool)
    
    func updateDateOfBirth(date: Date)
    
}

class DateOfBirthViewModel: AccountRowViewModel {
    
    weak var delegate: DateOfBirthViewModelDelegate?
    var dateOfBirth: DynamicType<Date>?
    
    init() {
        dateOfBirth = DynamicType<Date>(value: Date())
    }
    
}
