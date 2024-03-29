//
//  AccountSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class AccountSectionViewModel {
    
    var accountRowViewModels: DynamicType<[AccountRowViewModel]>?
    
    init() {
        accountRowViewModels = DynamicType<[AccountRowViewModel]>(value: [AccountRowViewModel]())
    }
    
}
