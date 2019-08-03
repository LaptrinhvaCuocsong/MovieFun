//
//  LoginViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/2/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    var isLoading: DynamicType<Bool>?
    var isLoginSuccess: DynamicType<Bool>?
    var isRegisterSuccess: DynamicType<Bool>?
    
    init() {
        isLoading = DynamicType<Bool>(value: false)
        isLoginSuccess = DynamicType<Bool>(value: false)
        isRegisterSuccess = DynamicType<Bool>(value: false)
    }
    
}
