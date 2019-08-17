//
//  CommentListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var commentListTableView: UITableView!
    
    private let HEIGHT_OF_CELL = 80.0
    
    var viewModel: CommentListViewModel {
        get {
            return controller.commentListViewModel!
        }
    }
    
    lazy var controller: CommentListController = {
        return CommentListController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        registerCell()
        initBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AccountService.share.isLogin() {
            controller.start()
        }
        else {
            AlertService.share.showAlertRequestLogin(for: self) {[weak self] in
                if let tabBarController = self?.tabBarController, let viewControllers = tabBarController.viewControllers {
                    let index = TabbarItem.account.rawValue
                    if viewControllers.count > index {
                        tabBarController.selectedIndex = index
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    //MARK: - Private method
    
    @objc func commentForMovie(_ notification:Notification) {
        if let userInfo = notification.userInfo, let movieId = userInfo[Constants.USER_INFO_MOVIE_ID_KEY] as? Int {
            let chatVC = ChatViewController.createChatViewControlelr(movieId: "\(movieId)")
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(commentForMovie(_:)), name: .COMMENT_TO_MOVIE_NOTIFICATION_KEY, object: nil)
    }
    
    private func registerCell() {
        commentListTableView.register(UINib(nibName: CommentListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CommentListTableViewCell.cellIdentify)
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.commentListTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
    }
    
    //MARK - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.commentListSectionViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = viewModel.commentListSectionViewModels!.value![section]
        return sectionVM.commentListRowViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVM = viewModel.commentListSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.commentListRowViewModels!.value![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentListTableViewCell.cellIdentify, for: indexPath) as! CommentListTableViewCell
        cell.setUp(with: rowVM)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }

}
