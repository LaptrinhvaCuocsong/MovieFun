//
//  Account.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class Account {
    
    var accountId: String
    var username: String
    var email: String
    var address: String
    var dateOfBirth: Date
    
    init() {
        accountId = "AccountId"
        username = "Username"
        email = "Email"
        address = "Address"
        dateOfBirth = Date()
    }
    
}
