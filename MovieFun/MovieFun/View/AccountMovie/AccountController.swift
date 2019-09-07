//
//  AccountController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class AccountController {
    
    var accountViewModel: AccountViewModel?
    var dispatchGroup: DispatchGroup!
    var didStart = false
    
    init(viewModel: AccountViewModel) {
        accountViewModel = viewModel
        dispatchGroup = DispatchGroup()
    }
    
    deinit {
        removeListener()
    }
    
    func start() {
        if let accountId = AccountService.share.getAccountId() {
            didStart = false
            removeListener()
            dispatchGroup.enter()
            accountViewModel?.isFetching?.value = true
            AccountService.share.fetchAccount(userId: accountId) {[weak self] (account, error) in
                if error == nil && account != nil {
                    self?.buildViewModel(account: account!)
                    self?.addListener()
                }
                self?.dispatchGroup.leave()
            }
            dispatchGroup.enter()
            StorageService.share.downloadImage(accountId: accountId) {[weak self] (data, error) in
                if error == nil && data != nil {
                    if let image = UIImage(data: data!) {
                        self?.accountViewModel?.accountImage?.value = image
                    }
                }
                self?.dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {[weak self] in
                self?.accountViewModel?.isFetching?.value = false
            }
        }
    }
    
    func addListener() {
        AccountService.share.addListener {[weak self] (account, error) in
            if !(self?.didStart ?? false) {
                self?.didStart = true
                return
            }
            if error == nil {
                if let account = account {
                    self?.accountViewModel?.haveChangeAccountInfo?.value = false
                    self?.buildViewModel(account: account)
                    self?.accountViewModel?.haveChangeAccountInfo?.value = true
                }
            }
        }
    }
    
    func removeListener() {
        AccountService.share.removeListener()
    }
    
    private func buildViewModel(account: Account) {
        accountViewModel?.account = account
        accountViewModel?.username?.value = account.username
        accountViewModel?.email?.value = account.email
        accountViewModel?.accountSectionViewModels?.value?.removeAll()
        let accountSectionVM = AccountSectionViewModel()
        accountViewModel?.accountSectionViewModels?.value?.append(accountSectionVM)
        let usernameVM = UsernameViewModel()
        usernameVM.delegate = accountViewModel
        usernameVM.username?.value = account.username
        accountSectionVM.accountRowViewModels?.value?.append(usernameVM)
        let emailVM = EmailViewModel()
        emailVM.delegate = accountViewModel
        emailVM.email?.value = account.email
        accountSectionVM.accountRowViewModels?.value?.append(emailVM)
        let addressVM = AddressViewModel()
        addressVM.delegate = accountViewModel
        addressVM.address?.value = account.address
        accountSectionVM.accountRowViewModels?.value?.append(addressVM)
        let dateOfBirthVM = DateOfBirthViewModel()
        dateOfBirthVM.delegate = accountViewModel
        dateOfBirthVM.dateOfBirth?.value = account.dateOfBirth
        accountSectionVM.accountRowViewModels?.value?.append(dateOfBirthVM)
    }
    
    func logout(delay: TimeInterval) {
        accountViewModel?.logoutSuccess?.value = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {[weak self] in
            AccountService.share.logout()
            self?.accountViewModel?.logoutSuccess?.value = true
        }
    }
    
    func updateUsername(username: String) {
        if let account = accountViewModel?.account {
            accountViewModel?.isFetching?.value = true
            account.username = username
            AccountService.share.updateAccount(account: account) {[weak self] (error) in
                if error == nil {
                    self?.buildViewModel(account: account)
                    self?.accountViewModel?.isUpdate?.value = true
                }
                else {
                    self?.accountViewModel?.isUpdate?.value = false
                }
                self?.accountViewModel?.isFetching?.value = false
            }
        }
    }
    
    func updateAddress(address: String) {
        if let account = accountViewModel?.account {
            accountViewModel?.isFetching?.value = true
            account.address = address
            AccountService.share.updateAccount(account: account) {[weak self] (error) in
                if error == nil {
                    self?.buildViewModel(account: account)
                    self?.accountViewModel?.isUpdate?.value = true
                }
                else {
                    self?.accountViewModel?.isUpdate?.value = false
                }
                self?.accountViewModel?.isFetching?.value = false
            }
        }
    }
    
    func updateDateOfBirth(date: Date) {
        if let account = accountViewModel?.account {
            accountViewModel?.isFetching?.value = true
            account.dateOfBirth = date
            AccountService.share.updateAccount(account: account) {[weak self] (error) in
                if error == nil {
                    self?.buildViewModel(account: account)
                    self?.accountViewModel?.isUpdate?.value = true
                }
                else {
                    self?.accountViewModel?.isUpdate?.value = false
                }
                self?.accountViewModel?.isFetching?.value = false
            }
        }
    }
    
    func uploadImage(image: UIImage) {
        if let imageData = StorageService.share.getData(image: image) {
            accountViewModel?.isFetching?.value = true
            StorageService.share.putImage(imageData: imageData) {[weak self] (metadata, error) in
                if error == nil && metadata != nil {
                    self?.accountViewModel?.accountImage?.value = image
                }
                self?.accountViewModel?.isFetching?.value = false
            }
        }
    }
    
}
