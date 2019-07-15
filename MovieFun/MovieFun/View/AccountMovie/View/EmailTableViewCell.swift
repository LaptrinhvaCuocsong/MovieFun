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
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let emailVM = viewModel as? EmailViewModel {
            setContent(email: emailVM.email?.value)
        }
    }
    
    func isEdit() -> Bool {
        return false
    }
    
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction? {
        return nil
    }
    
    private func setContent(email: String?) {
        emailLabel.text = email
    }
    
}
