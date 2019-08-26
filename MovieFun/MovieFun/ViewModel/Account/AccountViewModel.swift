//
//  AccountViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

protocol AccountViewModelDelegate: class {
    
    func present(viewController: UIViewController, animated: Bool)
    
    func updateUsername(username: String)
    
    func updateAddress(address: String)
    
    func updateDateOfBirth(date: Date)
    
}

class AccountViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: AccountViewModelDelegate?
    var isUpdate: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var accountImage: DynamicType<UIImage>?
    var username: DynamicType<String>?
    var email: DynamicType<String>?
    var accountSectionViewModels: DynamicType<[AccountSectionViewModel]>?
    var logoutSuccess: DynamicType<Bool>?
    var account: Account?
    
    private let HEIGHT_OF_CELL = 80.0
    
    override init() {
        super.init()
        logoutSuccess = DynamicType<Bool>(value: false)
        isUpdate = DynamicType<Bool>(value: false)
        isFetching = DynamicType<Bool>(value: false)
        accountImage = DynamicType<UIImage>(value: UIImage(named: Constants.IMAGE_NOT_FOUND)!)
        email = DynamicType<String>(value: "")
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
    
    //MARKL - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell as? AccountCell {
            if let editAction = cell.editAction() {
                return UISwipeActionsConfiguration(actions: [editAction])
            }
        }
        return nil
    }
    
}

extension AccountViewModel: UsernameViewModelDelegate, EmailViewModelDelegate,AddressViewModelDelegate, DateOfBirthViewModelDelegate {
    
    func updateDateOfBirth(date: Date) {
        delegate?.updateDateOfBirth(date: date)
    }
    
    func present(viewController: UIViewController, animated: Bool) {
        delegate?.present(viewController: viewController, animated: animated)
    }
    
    func updateUsername(username: String) {
        delegate?.updateUsername(username: username)
    }
    
    func updateAddress(address: String) {
        delegate?.updateAddress(address: address)
    }

}
