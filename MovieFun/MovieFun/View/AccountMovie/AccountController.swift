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
    
    init(viewModel: AccountViewModel) {
        accountViewModel = viewModel
    }
    
    func start() {
        //fetch personal info
        buildViewModel()
    }
    
    private func buildViewModel() {
        //demo
        let accountSectionVM = AccountSectionViewModel()
        accountViewModel?.accountSectionViewModels?.value?.append(accountSectionVM)
        let usernameVM = UsernameViewModel()
        usernameVM.imageName?.value = "man"
        usernameVM.username?.value = "hungmanh"
        accountSectionVM.accountRowViewModels?.value?.append(usernameVM)
        let emailVM = EmailViewModel()
        emailVM.email?.value = "kasavavava@gmail.com"
        accountSectionVM.accountRowViewModels?.value?.append(emailVM)
        let addressVM = AddressViewModel()
        addressVM.address?.value = "Ha Noi"
        accountSectionVM.accountRowViewModels?.value?.append(addressVM)
        let dateOfBirthVM = DateOfBirthViewModel()
        dateOfBirthVM.dateOfBirth?.value = Date()
        accountSectionVM.accountRowViewModels?.value?.append(dateOfBirthVM)
    }
    
}
