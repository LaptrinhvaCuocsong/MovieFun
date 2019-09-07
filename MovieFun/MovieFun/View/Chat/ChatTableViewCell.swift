//
//  ChatTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell, ChatCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var marginRightMessageView: NSLayoutConstraint!
    @IBOutlet weak var marginTopMessageViewChatLeft: NSLayoutConstraint!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let viewModel = chatViewModel {
            if viewModel is ChatLeftRowViewModel {
                accountImageView.layer.cornerRadius = CGFloat(accountImageView.width / 2.0)
                accountImageView.clipsToBounds = true
            }
        }
    }
    
    func setUp(with viewModel: ChatRowViewModel) {
        chatViewModel = viewModel
        messageView.isHidden = true
        if viewModel is ChatLeftRowViewModel {
            setUpChatLeft(viewModel: viewModel as! ChatLeftRowViewModel)
        }
        else if viewModel is ChatRightRowViewModel {
            setUpChatRight(viewModel: viewModel as! ChatRightRowViewModel)
        }
        messageView.isHidden = false
    }
    
    private func setUpChatLeft(viewModel: ChatLeftRowViewModel) {
        messageLabel.text = viewModel.currentMessage?.content
        let previousAccId = viewModel.previousMessage?.accountId
        let currentAccId = viewModel.currentMessage?.accountId
        if previousAccId != currentAccId {
            setUpAccountImage(accountId: currentAccId!)
            accountNameLabel.text = viewModel.currentMessage?.accountName
            accountNameLabel.isHidden = false
            marginTopMessageViewChatLeft.constant = 5.0
        }
        else {
            accountImageView.image = nil
            accountNameLabel.isHidden = true
            marginTopMessageViewChatLeft.constant = -20.0
        }
    }
    
    private func setUpChatRight(viewModel: ChatRightRowViewModel) {
        initBinding()
        messageLabel.text = viewModel.currentMessage?.content
    }
    
    private func setUpAccountImage(accountId: String) {
        if let accountImage = CacheService.share.getObject(key: accountId as NSString) {
            accountImageView.image = accountImage
            return
        }
        accountImageView.image = nil
        StorageService.share.downloadImage(accountId: accountId, completion: {[weak self] (data, error) in
            if error == nil && data != nil {
                let image = UIImage(data: data!)
                self?.accountImageView.image = image
                CacheService.share.setObject(key: accountId as NSString, image: image!)
            }
        })
    }
    
    private func initBinding() {
        if let chatRightVM = chatViewModel as? ChatRightRowViewModel {
            chatRightVM.addMessagesSuccess?.listener = {[weak self] (success) in
                if success {
                    self?.errorIcon.isHidden = true
                    self?.marginRightMessageView.constant = -16.0
                }
                else {
                    self?.errorIcon.isHidden = false
                    self?.marginRightMessageView.constant = 10.0
                }
                self?.layoutIfNeeded()
            }
        }
    }
    
}
