//
//  AccountService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AccountService {
    
    static let share = AccountService()
    
    private var accountId: String?
    private let db = Firestore.firestore()
    
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
    
    func updateAccount(account: Account, completion: ((Error?) -> Void)?) {
        let completion:((Error?) -> Void) = completion ?? {_ in}
        db.collection("account").document(account.accountId).setData([
            "accountId": account.accountId,
            "username": account.username,
            "email": account.email,
            "address": account.address,
            "dateOfBirth": account.dateOfBirth
        ]) { (error) in
            completion(error)
        }
    }
    
    func fetchAccount(userId: String, completion: ((Account?, Error?) -> Void)?) {
        let completion:((Account?, Error?) -> Void) = completion ?? {_,_ in}
        db.collection("account").document(userId).getDocument { (query, error) in
            if error == nil {
                if let document = query?.data() {
                    let account = Account()
                    account.accountId = document["accountId"] as! String
                    account.username = document["username"] as! String
                    account.email = document["email"] as! String
                    account.address = document["address"] as! String
                    account.dateOfBirth = (document["dateOfBirth"] as! Timestamp).dateValue()
                    completion(account, nil)
                }
                else {
                    completion(nil, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func addAccount(account: Account, completion: ((Error?) -> Void)?) {
        let completion:((Error?) -> Void) = completion ?? {_ in}
        db.collection("account").document(account.accountId).setData([
            "accountId": account.accountId,
            "username": account.username,
            "email": account.email,
            "address": account.address,
            "dateOfBirth": account.dateOfBirth
        ]) { (error) in
            completion(error)
        }
    }
    
}
