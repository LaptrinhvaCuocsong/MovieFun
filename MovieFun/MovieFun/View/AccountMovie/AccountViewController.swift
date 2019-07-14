//
//  AccountViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var accountTableView: UITableView!
    
    var viewModel: AccountViewModel {
        get {
            return controller.accountViewModel!
        }
    }
    
    lazy var controller: AccountController = {
       return AccountController(viewModel: AccountViewModel())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccountTableView()
        setImageView()
        controller.start()
    }
    
    private func initBinding() {
        viewModel.accountImage?.listener = {[weak self] (image) in
            self?.accountImageView.image = image
        }
        viewModel.username?.listener = {[weak self] (username) in
            self?.usernameLabel.text = username
        }
    }
    
    private func setAccountTableView() {
        accountTableView.delegate = viewModel
        accountTableView.dataSource = viewModel
        accountTableView.separatorColor = .none
        registerCell()
    }
    
    private func registerCell() {
        accountTableView.register(UINib(nibName: UsernameTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UsernameTableViewCell.cellIdentify)
        accountTableView.register(UINib(nibName: EmailTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: EmailTableViewCell.cellIdentify)
        accountTableView.register(UINib(nibName: AddressTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: AddressTableViewCell.cellIdentify)
        accountTableView.register(UINib(nibName: DateOfBirthTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: DateOfBirthTableViewCell.cellIdentify)
    }
    
    private func setImageView() {
        accountImageView.layer.cornerRadius = CGFloat(accountImageView.width/2)
        accountImageView.clipsToBounds = true
    }
    
}
