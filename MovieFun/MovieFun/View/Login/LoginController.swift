//
//  LoginController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/2/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class LoginController {
    
    var loginViewModel: LoginViewModel?
    
    init() {
        loginViewModel = LoginViewModel()
    }
    
    func login(email: String, password: String) {
        loginViewModel?.isLoading?.value = true
        AccountService.share.login(email: email, password: password) {[weak self] (user, error) in
            self?.loginViewModel?.isLoading?.value = false
            if error == nil {
                if let user = user {
                    AccountService.share.saveAccountId(accountId: user.uid)
                    self?.loginViewModel?.isLoginSuccess?.value = true
                }
                else {
                    self?.loginViewModel?.isLoginSuccess?.value = false
                }
            }
            else {
                self?.loginViewModel?.isLoginSuccess?.value = false
            }
        }
    }
    
    func register(email: String, password: String) {
        loginViewModel?.isLoading?.value = true
        AccountService.share.register(email: email, password: password) {[weak self] (user, error) in
            self?.loginViewModel?.isLoading?.value = false
            if error == nil {
                if let user = user {
                    let account = Account()
                    account.accountId = user.uid
                    account.email = user.email!
                    AccountService.share.addAccount(account: account, completion: { (error) in
                        if error == nil {
                            self?.loginViewModel?.isRegisterSuccess?.value = true
                        }
                        else {
                            self?.loginViewModel?.isRegisterSuccess?.value = false
                        }
                    })
                }
            }
            else {
                self?.loginViewModel?.isRegisterSuccess?.value = false
            }
        }
    }
    
}
