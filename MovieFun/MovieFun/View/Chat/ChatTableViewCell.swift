//
//  ChatTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import FirebaseStorage

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var widthMessageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var marginRightMessageView: NSLayoutConstraint!
    
    static let cellLeftNibName = "ChatLeftTableViewCell"
    static let cellRightNibName = "ChatRightTableViewCell"
    static let cellLeftIdentify = "chatLeftTableViewCell"
    static let cellRightIdentify = "chatRightTableViewCell"
    private let storageRef = StorageService.share.storage
    var chatViewModel: ChatRowViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 5.0
    }
    
    func setUp(viewModel: ChatRowViewModel) {
        messageLabel.text = viewModel.currentMessage?.content
        let width = messageLabel.intrinsicContentSize.width
        if width <= widthMessageViewConstraint.constant {
            widthMessageViewConstraint.constant = width + 10.0/*margin left*/ + 10.0/*margin right*/
        }
        if let previousAccId = viewModel.previousMessage?.accountId, let currentAccId = viewModel.currentMessage?.accountId {
            if previousAccId != currentAccId {
                AccountService.share.fetchAccount(userId: currentAccId) {[weak self] (account, error) in
                    if error == nil && account != nil {
                        if let accountId = account?.accountId {
                            if let ref = self?.storageRef.reference().child(accountId) {
                                self?.accountImageView.setImage(storeRef: ref)
                            }
                        }
                    }
                }
                if viewModel is ChatLeftRowViewModel {
                    accountNameLabel.text = viewModel.currentMessage?.accountName
                }
            }
        }
        // Set hidden error icon
        if let chatRightViewModel = viewModel as? ChatRightRowViewModel, let addMessageSuccess = chatRightViewModel.addMessagesSuccess {
            if addMessageSuccess {
                errorIcon.isHidden = true
                marginRightMessageView.constant = -16.0
                layoutIfNeeded()
                return
            }
        }
        errorIcon.isHidden = false
        marginRightMessageView.constant = 10.0
        layoutIfNeeded()
    }
    
}
