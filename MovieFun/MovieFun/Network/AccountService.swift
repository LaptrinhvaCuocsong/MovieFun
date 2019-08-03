//
//  AccountService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import FirebaseAuth

class AccountService {
    
    static let share = AccountService()
    
    private var accountId: String?
    
    func getAccountId() -> String? {
        if accountId == nil {
            return UserDefaults.standard.string(forKey: "userLogin")
        }
        return accountId
    }
    
    func setAccountId(accountId: String) {
        self.accountId = accountId
        UserDefaults.standard.set(accountId, forKey: "userLogin")
    }
    
    func isLogin() -> Bool {
        return AccountService.share.getAccountId() == nil ? false : true
    }
    
    func login(email: String, password: String, completion: ((User?, Error?) -> Void)?) {
        let completion: ((User?, Error?) -> Void) = completion ?? {_,_ in}
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(result?.user, error)
        }
    }
    
    func register(email: String, password: String, completion: ((User?, Error?) -> Void)?) {
        let completion: ((User?, Error?) -> Void) = completion ?? {_,_ in}
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            completion(result?.user, error)
        }
    }
    
    func fetchAccount(userId: String, completion: ((Account?) -> Void)?) {
        
    }
    
}
