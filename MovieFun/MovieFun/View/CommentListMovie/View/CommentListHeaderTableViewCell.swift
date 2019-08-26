//
//  CommentListHeaderTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class CommentListHeaderTableViewCell: UITableViewCell, CommentListCell {
    
    static let nibName = "CommentListHeaderTableViewCell"
    static let cellIdentify = "commentListHeaderTableViewCell"
    var commHeaderVM: CommentListHeaderRowViewModel?
    
    func setUp(with viewModel: CommentListBaseRowViewModel) {
        if let viewModel = viewModel as? CommentListHeaderRowViewModel {
            commHeaderVM = viewModel
        }
    }
    
    @IBAction func addComment(_ sender: Any) {
    }
}
