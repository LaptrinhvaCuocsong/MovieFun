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
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var commentListTableView: UITableView!
    @IBOutlet weak var heightSearchBarView: NSLayoutConstraint!
    @IBOutlet weak var marginTopTableView: NSLayoutConstraint!
    
    private let HEIGHT_OF_CELL = 80.0
    private let HEIGHT_OF_HEADER_CELL = 58.0
    
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
        registerCell()
        initBinding()
        NotificationCenter.default.addObserver(self, selector: #selector(commentForMovie(_:)), name: .COMMENT_TO_MOVIE_NOTIFICATION_KEY, object: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private method
    
    @objc func commentForMovie(_ notification:Notification) {
        if let userInfo = notification.userInfo, let movie = userInfo[Constants.USER_INFO_MOVIE_KEY] as? Movie {
            self.navigationController?.popToRootViewController(animated: false)
            let chatVC = ChatViewController.createChatViewControlelr(movie: movie)
            chatVC.delegate = self
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    private func registerCell() {
        commentListTableView.register(UINib(nibName: CommentListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CommentListTableViewCell.cellIdentify)
        commentListTableView.register(UINib(nibName: CommentListHeaderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CommentListHeaderTableViewCell.cellIdentify)
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
        viewModel.isHiddenSearchBar?.listener = {[weak self] (isHidden) in
            if isHidden {
                self?.hideSearchBarView(isHidden: true)
            }
            else {
                self?.hideSearchBarView(isHidden: false)
            }
        }
    }
    
    private func hideSearchBarView(isHidden: Bool) {
        if isHidden {
            searchBarView.isHidden = true
            marginTopTableView.constant = -1.0 * heightSearchBarView.constant
        }
        else {
            searchBarView.isHidden = false
            marginTopTableView.constant = 0.0
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
        if let cellIdentify = controller.cellIdentify(rowVM: rowVM) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
            if let cell = cell as? CommentListCell {
                cell.setUp(with: rowVM)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionVM = viewModel.commentListSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.commentListRowViewModels!.value![indexPath.row]
        if rowVM is CommentListHeaderRowViewModel {
            return CGFloat(HEIGHT_OF_HEADER_CELL)
        }
        return CGFloat(HEIGHT_OF_CELL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = viewModel.commentListSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.commentListRowViewModels!.value![indexPath.row]
        if let rowVM = rowVM as? CommentListRowViewModel {
            if let groupComment = rowVM.groupComment?.value, let movie = groupComment.movie {
                let chatVC = ChatViewController.createChatViewControlelr(movie: movie)
                chatVC.delegate = self
                navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }

}

extension CommentListViewController: ChatViewControllerDelegate {
    
    func addGroupMessage(_ groupMessage: GroupComment, _ completion: ((Error?) -> Void)?) {
        let completion:((Error?) -> Void) = completion ?? {_ in}
        controller.addGroupComment(groupMessage: groupMessage) { (addSuccess, error) in
            completion(error)
        }
    }
    
}
