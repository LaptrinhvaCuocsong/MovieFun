//
//  UsernameTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class UsernameTableViewCell: UITableViewCell, AccountCell {
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let nibName = "UsernameTableViewCell"
    static let cellIdentify = "usernameTableViewCell"
    
    func setUp(with viewModel: AccountRowViewModel) {
        if let usernameVM = viewModel as? UsernameViewModel {
            setContent(imageName: usernameVM.imageName?.value, username: usernameVM.username?.value)
        }
    }
    
    private func setContent(imageName: String?, username: String?) {
        accountImage.image = UIImage(named: imageName ?? "image-not-found")
        usernameLabel.text = username
    }
    
}
