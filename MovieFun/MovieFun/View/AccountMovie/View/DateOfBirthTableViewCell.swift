//
//  DateOfBirthTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class DateOfBirthTableViewCell: UITableViewCell, AccountCell {

    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    static let nibName = "DateOfBirthTableViewCell"
    static let cellIdentify = "dateOfBirthTableViewCell"
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let dateOfBirthVM = viewModel as? DateOfBirthViewModel {
            setContent(dateOfBirth: dateOfBirthVM.dateOfBirth?.value)
        }
    }
    
    func isEdit() -> Bool {
        return true
    }
    
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction? {
        return nil
    }
    
    private func setContent(dateOfBirth: Date?) {
        dateOfBirthLabel.text = Utils.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: dateOfBirth)
    }
    
}
