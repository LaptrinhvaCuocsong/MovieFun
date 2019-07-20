//
//  CommentTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/20/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell, MovieDetailCell {
    
    var commentVM: CommentViewModel?
    static let nibName = "CommentTableViewCell"
    static let cellIdentify = "commentTableViewCell"
    
    func setUp(with viewModel: MovieDetailRowViewModel) {
        if let viewModel = viewModel as? CommentViewModel {
            commentVM = viewModel
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func commentForMovie(_ sender: Any) {
    }
    
}
