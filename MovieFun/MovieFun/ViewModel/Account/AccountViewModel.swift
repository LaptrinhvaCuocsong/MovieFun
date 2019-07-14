//
//  AccountViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class AccountViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var accountImage: DynamicType<UIImage>?
    var username: DynamicType<String>?
    var accountSectionViewModels: DynamicType<[AccountSectionViewModel]>?
    
    override init() {
        super.init()
        accountImage = DynamicType<UIImage>(value: UIImage(named: "image-not-found")!)
        username = DynamicType<String>(value: "")
        accountSectionViewModels = DynamicType<[AccountSectionViewModel]>(value: [AccountSectionViewModel]())
    }
    
    private func cellIdentify(viewModel: AccountRowViewModel) -> String? {
        switch viewModel {
        case is UsernameViewModel:
            return UsernameTableViewCell.cellIdentify
        case is EmailViewModel:
            return EmailTableViewCell.cellIdentify
        case is AddressViewModel:
            return AddressTableViewCell.cellIdentify
        case is DateOfBirthViewModel:
            return DateOfBirthTableViewCell.cellIdentify
        default:
            return nil
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountSectionViewModels!.value!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = accountSectionViewModels!.value![section]
        return sectionVM.accountRowViewModels!.value!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVM = accountSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.accountRowViewModels!.value![indexPath.row]
        if let cellIdentify = cellIdentify(viewModel: rowVM) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
            if let cell = cell as? AccountCell {
                cell.setUp(with: rowVM)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
