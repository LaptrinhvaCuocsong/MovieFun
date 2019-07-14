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
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let addressVM = viewModel as? AddressViewModel {
            setContent(address: addressVM.address?.value)
        }
    }
    
    private func setContent(address: String?) {
        addressLabel.text = address
    }
    
}
