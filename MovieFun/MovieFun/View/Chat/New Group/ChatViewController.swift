//
//  ChatViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos

protocol ChatViewControllerDelegate: class {
    
    func addGroupMessage(_ groupMessage: GroupComment, _ completion: ((Error?) -> Void)?)
    
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: MFTextView!
    @IBOutlet weak var heightMessageTextView: NSLayoutConstraint!
    @IBOutlet weak var heightChatTextView: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var heightImageCollectionView: NSLayoutConstraint!
    
    weak var delegate: ChatViewControllerDelegate?
    var movie: Movie!
    private let HEIGHT_OF_HEADER_VIEW = 30.0
    private let defaultHeightMessageTextView: CGFloat = 40.0
    private var maxHeightMessageTextView: CGFloat = 160.0
    private let defaultHeightCollectionView: CGFloat = 0.0
    private var maxHeightCollectionView: CGFloat = 0.0
    private var tapViewGesture: UIGestureRecognizer!
    private var isSelectingImage: Bool = false
    
    static func createChatViewControlelr(movie: Movie) -> ChatViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.MAIN.rawValue, bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.movie = movie
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
        messageTextView.layer.cornerRadius = 6.0
        messageTextView.clipsToBounds = true
        messageTextView.placeholder = "Send your comment ..."
        messageTextView.myDelegate = self
        tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapViewGesture!)
        chatTableView.estimatedRowHeight = CGFloat(80.0)
        registerCell()
        initBinding()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let movieId = self.movie.id {
            viewModel.movieId = "\(movieId)"
            controller.start()
        }
        navigationController?.hidesBarsOnSwipe = true
        messageTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Private method
    
    @objc private func hideKeyboard() {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
        if isSelectingImage {
            resetMessageTextView()
        }
    }
    
    @objc private func showKeyboard(notification: Notification) {
        var safeAreaInsetBottom:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            safeAreaInsetBottom = view.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
            safeAreaInsetBottom = bottomLayoutGuide.length
        }
        if let userInfo = notification.userInfo {
            UIView.animate(withDuration: 0.5) {[weak self] in
                let keyboardFrame = userInfo["UIKeyboardFrameEndUserInfoKey"]! as! CGRect
                self?.maxHeightCollectionView = keyboardFrame.size.height - safeAreaInsetBottom
                self?.heightChatTextView.constant = CGFloat(10.0) + CGFloat(self?.heightMessageTextView.constant ?? 0) + CGFloat(10.0) + keyboardFrame.size.height - safeAreaInsetBottom
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func willHideKeyboard(notification: Notification) {
        UIView.animate(withDuration: 0.5) {[weak self] in
            if !(self?.isSelectingImage ?? false) {
                self?.resetMessageTextView()
            }
        }
    }
    
    private func registerCell() {
        chatTableView.register(UINib(nibName: ChatTableViewCell.cellLeftNibName, bundle: nil), forCellReuseIdentifier: ChatTableViewCell.cellLeftIdentify)
        chatTableView.register(UINib(nibName: ChatTableViewCell.cellRightNibName, bundle: nil), forCellReuseIdentifier: ChatTableViewCell.cellRightIdentify)
        chatTableView.register(UINib(nibName: HeaderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: HeaderTableViewCell.cellIdentify)
    }
    
    private func resetMessageTextView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {[weak self] in
            self?.heightMessageTextView.constant = self?.defaultHeightMessageTextView ?? 0.0
            self?.messageTextView.isScrollEnabled = true
            self?.heightChatTextView.constant = CGFloat(10.0) + CGFloat(self?.heightMessageTextView.constant ?? 0.0) + CGFloat(10.0)
            self?.heightImageCollectionView.constant = 0.0
            self?.view.layoutIfNeeded()
        }, completion: nil)
        isSelectingImage = false
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self?.chatTableView.reloadData()
                    SVProgressHUD.dismiss()
                    self?.scrollToBottomTableView(false)
                }
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.haveAddMessage?.listener = {[weak self] (haveAddMessage) in
            if (haveAddMessage) {
                let length = self?.viewModel.sectionViewModels?.value?.count ?? 0
                if length > 0 {
                    DispatchQueue.main.async {
                        self?.chatTableView.reloadData()
                        self?.scrollToBottomTableView(true)
                    }
                }
            }
        }
        viewModel.receiveMessageSuccess?.listener = {[weak self] (receiveMessageSuccess) in
            if (receiveMessageSuccess) {
                let length = self?.viewModel.sectionViewModels?.value?.count ?? 0
                if length > 0 {
                    DispatchQueue.main.async {
                        self?.chatTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func scrollToBottomTableView(_ animated: Bool) {
        let y = chatTableView.contentOffset.y
        let contentHeight = chatTableView.contentSize.height
        if y + CGFloat(chatTableView.height) <= contentHeight {
            let numberSectionVMs = viewModel.sectionViewModels?.value?.count ?? 0
            if let lastSectionVM = viewModel.sectionViewModels?.value?.last, let numberRowVMs = lastSectionVM.rowViewModels?.value?.count {
                let indexPath = IndexPath(row: numberRowVMs - 1, section: numberSectionVMs - 1)
                chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func sendMessage(_ sender: Any) {
        let text = messageTextView.text!
        if text != "" {
            controller.addMessage(text) {[weak self] (message) in
                if let movie = self?.movie {
                    let groupMessage = GroupComment()
                    groupMessage.movie = movie
                    groupMessage.newMessage = text
                    groupMessage.newSenderName = message.accountName
                    groupMessage.sendDate = message.sendDate
                    self?.delegate?.addGroupMessage(groupMessage, nil)
                }
            }
            messageTextView.text = ""
        }
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
        if isSelectingImage {
            resetMessageTextView()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)
            if let cell = cell as? ChatCell {
                cell.setUp(with: rowVM)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(HEIGHT_OF_HEADER_VIEW)
        }
        return UITableView.automaticDimension
    }
    
    @IBAction func selectImages(_ sender: Any) {
        requestAuthentication()
    }
    
    private func showImageCollection() {
        isSelectingImage = true
        if !messageTextView.isFirstResponder {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {[weak self] in
                self?.heightImageCollectionView.constant = self?.maxHeightCollectionView ?? 0.0
                self?.heightChatTextView.constant = CGFloat(10.0) + CGFloat(self?.heightMessageTextView.constant ?? 0.0) + CGFloat(8.0) + CGFloat(self?.heightImageCollectionView.constant ?? 0.0)
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
        else {
            messageTextView.resignFirstResponder()
            heightImageCollectionView.constant = maxHeightCollectionView
        }
    }
    
    private func requestAuthentication() {
        let state = PHPhotoLibrary.authorizationStatus()
        switch state {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization {[weak self] (status) in
                if status == .authorized {
                    self?.showImageCollection()
                }
            }
            break
        case .restricted:
            fallthrough
        case .denied:
            AlertService.share.showAlertRequestOpenSetting(for: self, title: nil, message: "Allow us to use your photo gallery")
            break
        case .authorized:
            showImageCollection()
            break
        default:
            break
        }
    }
    
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let previousHeight = heightMessageTextView.constant
        let estimatedSize = textView.sizeThatFits(CGSize(width: messageTextView.frame.size.width, height: CGFloat.infinity))
        if estimatedSize.height > defaultHeightMessageTextView && estimatedSize.height <= maxHeightMessageTextView {
            heightMessageTextView.constant = estimatedSize.height
            messageTextView.isScrollEnabled = false
        }
        else if estimatedSize.height > maxHeightMessageTextView {
            messageTextView.isScrollEnabled = true
        }
        else {
            heightMessageTextView.constant = defaultHeightMessageTextView
        }
        let lastHeight = heightMessageTextView.constant
        heightChatTextView.constant += lastHeight - previousHeight
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
