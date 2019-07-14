//
//  UsernameViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class UsernameViewModel: AccountRowViewModel {

    var imageName: DynamicType<String>?
    var username: DynamicType<String>?
    
    init() {
        imageName = DynamicType<String>(value: "image-not-found")
        username = DynamicType<String>(value: "")
    }
    
}
