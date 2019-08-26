//
//  HeaderTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell, ChatCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    static let nibName = "HeaderTableViewCell"
    static let cellIdentify = "headerTableViewCell"
    
    func setUp(with viewModel: ChatRowViewModel) {
        if let headerRowVM = viewModel as? ChatHeaderRowViewModel {
            timeLabel.text = headerRowVM.sendDateStr
        }
    }
    
}
