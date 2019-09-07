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
    private var existAccount = false
    private var account: Account?
    private var listener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    
    func getAccountName() -> String? {
        return account?.username
    }
    
    func getAccountId() -> String? {
        if account?.accountId == nil {
            return UserDefaults.standard.string(forKey: "userLogin")
        }
        return account?.accountId
    }
    
    func saveAccountId(accountId: String) {
        UserDefaults.standard.set(accountId, forKey: "userLogin")
    }
    
    func isLogin() -> Bool {
        return account?.accountId == nil ? false : true
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
    
    func logout() {
        account = nil
        UserDefaults.standard.removeObject(forKey: "userLogin")
    }
    
    func addListener(completion: ((Account?,Error?) -> Void)?) {
        let completion:((Account?,Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = account?.accountId {
            listener = db.collection("account").document(accountId).addSnapshotListener({[weak self] (documentSnapshot, error) in
                if error == nil {
                    if let document = documentSnapshot?.data(), let accountId = document["accountId"] as? String {
                        let account = Account()
                        account.accountId = accountId
                        account.username = document["username"] as? String ?? ""
                        account.email = document["email"] as? String ?? "email@gmail.com"
                        account.address = document["address"] as? String ?? ""
                        account.dateOfBirth = (document["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date()
                        self?.account = account
                        completion(account, nil)
                    }
                    else {
                        completion(nil, nil)
                    }
                }
                else {
                    completion(nil, error)
                }
            })
        }
        else {
            completion(nil, nil)
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    func updateAccount(account: Account, completion: ((Error?) -> Void)?) {
        let completion:((Error?) -> Void) = completion ?? {_ in}
        self.account?.username = account.username
        self.account?.address = account.address
        self.account?.dateOfBirth = account.dateOfBirth
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
        db.collection("account").document(userId).getDocument {[weak self] (query, error) in
            if error == nil {
                if let document = query?.data() {
                    if let accountId = document["accountId"] as? String {
                        let account = Account()
                        account.accountId = accountId
                        account.username = document["username"] as? String ?? ""
                        account.email = document["email"] as? String ?? "email@gmail.com"
                        account.address = document["address"] as? String ?? ""
                        account.dateOfBirth = (document["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date()
                        self?.account = account
                        completion(account, nil)
                    }
                    else {
                        completion(nil, nil)
                    }
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
        ]) {[weak self] (error) in
            if error == nil {
                self?.account = account
                self?.saveAccountId(accountId: account.accountId)
            }
            completion(error)
        }
    }
    
}
