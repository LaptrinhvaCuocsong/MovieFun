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
    var dateOfBirthVM: DateOfBirthViewModel?
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let dateOfBirthVM = viewModel as? DateOfBirthViewModel {
            self.dateOfBirthVM = dateOfBirthVM
            setContent(dateOfBirth: dateOfBirthVM.dateOfBirth?.value)
        }
    }
    
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction? {
        let editAction = UIContextualAction(style: .normal, title: nil) {[weak self] (action, view, completion) in
            self?.dateOfBirthVM?.delegate?.present(viewController: self!.dateOfBirthAlertVC(), animated: true)
        }
        editAction.image = UIImage(named: "writing")
        editAction.backgroundColor = .cyan
        return editAction
    }
    
    private func dateOfBirthAlertVC() -> UIAlertController {
        let alertVC = UIAlertController(title: "Date Of Birth", message: nil, preferredStyle: .alert)
        alertVC.addTextField {[weak self] (textField) in
            textField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            textField.placeholder = "YYYY/MM/DD"
            textField.inputView = self?.datePicker()
        }
        alertVC.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alertVC
    }
    
    private func datePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }
    
    private func setContent(dateOfBirth: Date?) {
        dateOfBirthLabel.text = Utils.stringFromDate(dateFormat: Utils.YYYY_MM_DD, date: dateOfBirth)
    }
    
}
