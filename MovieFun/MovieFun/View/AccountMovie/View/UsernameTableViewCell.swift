//
//  UsernameTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class UsernameTableViewCell: UITableViewCell, AccountCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let nibName = "UsernameTableViewCell"
    static let cellIdentify = "usernameTableViewCell"
    var usernameVM: UsernameViewModel?
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let usernameVM = viewModel as? UsernameViewModel {
            self.usernameVM = usernameVM
            setContent(username: usernameVM.username?.value)
        }
    }
    
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction? {
        let editAction = UIContextualAction(style: .normal, title: nil) {[weak self] (action, view, completion) in
            self?.usernameVM?.delegate?.present(viewController: self!.usernameAlertVC(), animated: true)
        }
        editAction.image = UIImage(named: "writing")
        editAction.backgroundColor = .cyan
        return editAction
    }
    
    private func setContent(username: String?) {
        usernameLabel.text = username
    }
    
    private func usernameAlertVC() -> UIAlertController {
        let alertVC = UIAlertController(title: "Username", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (usernameTF) in
            usernameTF.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            usernameTF.placeholder = "Username"
        }
        alertVC.addAction(UIAlertAction(title: "Edit", style: .default, handler: {[weak self] (_) in
            if let usernameTF = alertVC.textFields?.first, let username = usernameTF.text {
                self?.usernameVM?.delegate?.updateUsername(username: username)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alertVC
    }
    
}
