//
//  CommentListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class CommentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var commentListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftImageForSearchTextField()
        setCommentListTableView()
    }
    
    private func setLeftImageForSearchTextField() {
        searchTextField.leftViewMode = .always
        let leftImageView = UIImageView(frame: CGRect(x: 10.0, y: 0.0, width: 20.0, height: searchTextField.height))
        leftImageView.image = UIImage(named: "search-32")
        leftImageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: searchTextField.height))
        view.addSubview(leftImageView)
        searchTextField.leftView = view
    }
    
    private func setCommentListTableView() {
        commentListTableView.separatorStyle = .none
        commentListTableView.separatorColor = .clear
    }
    
    //MARK - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
