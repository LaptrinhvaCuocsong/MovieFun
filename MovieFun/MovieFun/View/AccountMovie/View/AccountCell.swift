//
//  AccountCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/14/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

protocol AccountCell {
    
    func setUp(with viewModel: AccountRowViewModel)
        
    @available(iOS 11.0, *)
    func editAction() -> UIContextualAction?
    
}
