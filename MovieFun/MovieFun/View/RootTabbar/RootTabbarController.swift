//
//  RootTabbarController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/11/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class RootTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let accountId = AccountService.share.getAccountId() {
            AccountService.share.fetchAccount(userId: accountId, completion: nil)
        }
    }
}
