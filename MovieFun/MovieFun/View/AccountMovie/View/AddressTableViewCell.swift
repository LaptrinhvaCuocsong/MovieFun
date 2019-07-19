//
//  AddressTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell, AccountCell {

    @IBOutlet weak var addressLabel: UILabel!
    
    static let nibName = "AddressTableViewCell"
    static let cellIdentify = "addressTableViewCell"
    var addressVM: AddressViewModel?
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let addressVM = viewModel as? AddressViewModel {
            self.addressVM = addressVM
            setContent(address: addressVM.address?.value)
        }
    }
    
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction? {
        let editAction = UIContextualAction(style: .normal, title: nil) {[weak self] (action, view, completion) in
            self?.addressVM?.delegate?.present(viewController: self!.addressAlertVC(), animated: true)
        }
        editAction.image = UIImage(named: "writing")
        editAction.backgroundColor = .cyan
        return editAction
    }
    
    private func addressAlertVC() -> UIAlertController {
        let alertVC = UIAlertController(title: "Address", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            textField.placeholder = "Address"
        }
        alertVC.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alertVC
    }
    
    private func setContent(address: String?) {
        addressLabel.text = address
    }
    
}
