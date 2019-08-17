//
//  ChatViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var heightMessageView: NSLayoutConstraint!
    
    var movieId: String!
    private let HEIGHT_OF_HEADER_VIEW = 30.0
    private var tapViewGesture: UIGestureRecognizer!
    
    static func createChatViewControlelr(movieId: String) -> ChatViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.MAIN.rawValue, bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.movieId = movieId
        return chatVC
    }
    
    var viewModel: ChatViewModel {
        return controller.chatViewModel!
    }
    
    lazy var controller: ChatController = {
        return ChatController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapViewGesture!)
        chatTableView.estimatedRowHeight = CGFloat(80.0)
        registerCell()
        initBinding()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let movieId = self.movieId {
            viewModel.movieId = movieId
            controller.start()
        }
    }

    //MARK: - Private method
    
    @objc private func hideKeyboard() {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
    
    @objc private func showKeyboard() {
        print("Show keyboard")
    }
    
    @objc private func willHideKeyboard() {
        print("Hide keyboard")
    }
    
    private func registerCell() {
        chatTableView.register(UINib(nibName: ChatTableViewCell.cellLeftNibName, bundle: nil), forCellReuseIdentifier: ChatTableViewCell.cellLeftIdentify)
        chatTableView.register(UINib(nibName: ChatTableViewCell.cellRightNibName, bundle: nil), forCellReuseIdentifier: ChatTableViewCell.cellRightIdentify)
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.chatTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.haveAddMessage?.listener = {[weak self] (haveAddMessage) in
            if (haveAddMessage) {
                let length = self?.viewModel.sectionViewModels?.value?.count ?? 0
                if length > 0 {
                    self?.chatTableView.reloadData()
                }
            }
        }
        viewModel.addMessageSuccess?.listener = {[weak self] (addMessageSuccess) in
            if (addMessageSuccess) {
                let length = self?.viewModel.sectionViewModels?.value?.count ?? 0
                if length > 0 {
                    self?.chatTableView.reloadData()
                }
            }
        }
        viewModel.receiveMessageSuccess?.listener = {[weak self] (receiveMessageSuccess) in
            if (receiveMessageSuccess) {
                let length = self?.viewModel.sectionViewModels?.value?.count ?? 0
                if length > 0 {
                    self?.chatTableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func sendMessage(_ sender: Any) {
        let text = messageTextView.text!
        if text != "" {
            controller.addMessage(text)
            messageTextView.text = ""
        }
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
    
    //MARK: - UITableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = viewModel.sectionViewModels!.value![section]
        return sectionVM.rowViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVM = viewModel.sectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.rowViewModels!.value![indexPath.row]
        if let cellIdentifer = controller.cellIdentify(with: rowVM) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! ChatTableViewCell
            cell.setUp(viewModel: rowVM)
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionVM = viewModel.sectionViewModels!.value![section]
        if let sendDateStr = sectionVM.sendDateStr {
            let header = HeaderSectionChatTableView.createHeaderSectionChatTableView()
            header.setContent(timeStr: sendDateStr)
            return header
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(HEIGHT_OF_HEADER_VIEW)
    }
    
}
