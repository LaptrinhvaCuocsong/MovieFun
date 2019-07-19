//
//  EmailTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class EmailTableViewCell: UITableViewCell, AccountCell {

    @IBOutlet weak var emailLabel: UILabel!
    
    static let nibName = "EmailTableViewCell"
    static let cellIdentify = "emailTableViewCell"
    var emailVM: EmailViewModel?
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let emailVM = viewModel as? EmailViewModel {
            self.emailVM = emailVM
            setContent(email: emailVM.email?.value)
        }
    }
    
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction? {
        let editAction = UIContextualAction(style: .normal, title: nil) {[weak self] (action, view, completion) in
            self?.emailVM?.delegate?.present(viewController: self!.emailAlertVC(), animated: true)
        }
        editAction.image = UIImage(named: "writing")
        editAction.backgroundColor = .cyan
        return editAction
    }
    
    private func emailAlertVC() -> UIAlertController {
        let alertVC = UIAlertController(title: "Address", message: "Email can't edit", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alertVC
    }
    
    private func setContent(email: String?) {
        emailLabel.text = email
    }
    
}
