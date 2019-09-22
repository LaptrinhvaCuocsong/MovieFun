//
//  ChatTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import Photos

class ChatTableViewCell: UITableViewCell, ChatCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var heightMessageImageView: NSLayoutConstraint!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var marginRightMessageView: NSLayoutConstraint!
    @IBOutlet weak var marginTopMessageViewChatLeft: NSLayoutConstraint!
    @IBOutlet weak var marginRightMessImageView: NSLayoutConstraint!
    @IBOutlet weak var marginTopMessageLabel: NSLayoutConstraint!
    @IBOutlet weak var marginBottomMessageLabel: NSLayoutConstraint!
    @IBOutlet weak var buttonMessageImageView: UIButton!
    
    static let cellLeftNibName = "ChatLeftTableViewCell"
    static let cellRightNibName = "ChatRightTableViewCell"
    static let cellLeftIdentify = "chatLeftTableViewCell"
    static let cellRightIdentify = "chatRightTableViewCell"
    private let storageRef = StorageService.share.storage
    var chatViewModel: ChatRowViewModel?
    private let HEIGHT_CHAT_IMAGE: CGFloat = 300.0
    private let MIN_WIDTH_MESSAGE_LABEL: CGFloat = 40.0
    private var gestureLongPressButton: UIGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 8.0
        messageImageView.layer.cornerRadius = 8.0
        messageImageView.layer.borderColor = UIColor.lightGray.cgColor
        messageImageView.layer.borderWidth = 1.0
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
    
    @objc private func longPressButtonMessageImageView(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            buttonMessageImageView.backgroundColor = .clear
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.buttonMessageImageView.backgroundColor = .lightGray
            }
        }
        else if gesture.state == .ended {
            buttonMessageImageView.backgroundColor = .clear
            print("long touch end")
        }
    }
    
    func setUp(with viewModel: ChatRowViewModel) {
        chatViewModel = viewModel
        messageView.isHidden = true
        //set button message image view
        buttonMessageImageView.alpha = 0.5
        gestureLongPressButton = UILongPressGestureRecognizer(target: self, action: #selector(longPressButtonMessageImageView(gesture:)))
        buttonMessageImageView.addGestureRecognizer(gestureLongPressButton)
        //set message image
        for subView in messageImageView.subviews {
            subView.removeFromSuperview()
        }
        if viewModel is ChatLeftRowViewModel {
            setUpChatLeft(viewModel: viewModel as! ChatLeftRowViewModel)
        }
        else if viewModel is ChatRightRowViewModel {
            setUpChatRight(viewModel: viewModel as! ChatRightRowViewModel)
        }
        messageView.isHidden = false
        if messageLabel.text?.isEmpty ?? true {
            marginTopMessageLabel.constant = 0.0
            marginBottomMessageLabel.constant = 0.0
        }
        else {
            marginTopMessageLabel.constant = 15.0
            marginBottomMessageLabel.constant = 15.0
            let intrinsicSize = messageLabel.intrinsicContentSize
            if intrinsicSize.width <= MIN_WIDTH_MESSAGE_LABEL {
                messageLabel.textAlignment = .center
            }
            else {
                messageLabel.textAlignment = .left
            }
        }
    }
    
    private func setUpChatLeft(viewModel: ChatLeftRowViewModel) {
        messageLabel.text = viewModel.currentMessage?.content
        //set account image
        for subView in accountImageView.subviews {
            subView.removeFromSuperview()
        }
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
        if viewModel.currentMessage?.isMessageImage ?? false && viewModel.currentMessage?.imageName != nil {
            setUpChatImage(accountId: currentAccId!, viewModel: viewModel)
            heightMessageImageView.constant = HEIGHT_CHAT_IMAGE
        }
        else {
            messageImageView.image = nil
            heightMessageImageView.constant = 0.0
        }
    }
    
    private func setUpChatRight(viewModel: ChatRightRowViewModel) {
        initBinding()
        messageLabel.text = viewModel.currentMessage?.content
        //set hidden error icon
        errorIcon.isHidden = true
        //set message chat image
        let currentAccId = viewModel.currentMessage?.accountId
        if viewModel.currentMessage?.isMessageImage ?? false && (viewModel.currentMessage?.imageName != nil || viewModel.phAsset != nil) {
            setUpChatImage(accountId: currentAccId!, viewModel: viewModel)
            heightMessageImageView.constant = HEIGHT_CHAT_IMAGE
        }
        else {
            messageImageView.image = nil
            heightMessageImageView.constant = 0.0
        }
    }
    
    private func setUpChatImage(accountId: String, viewModel: ChatRowViewModel) {
        guard let imageName = viewModel.currentMessage?.imageName else {
            return
        }
        if let chatImage = CacheService.share.getObject(key: "\(accountId)/\(imageName)" as NSString) {
            messageImageView.image = chatImage
            return
        }
        messageImageView.image = nil
        messageImageView.addSpinnerView()
        let messImageView = UIImageView()
        messageImageView.addSubview(messImageView)
        messImageView.fillSuperView()
        if let viewModel = viewModel as? ChatRightRowViewModel, let phAsset = viewModel.phAsset {
            let targetSize = messageImageView.frame.size
            PhotoService.share.fetchImage(phAsset: phAsset, targetSize: targetSize) {[weak self] (image) in
                if let image = image {
                    messImageView.image = image
                    self?.messageImageView.removeSpinnerView()
                    CacheService.share.setObject(key: "\(accountId)/\(imageName)" as NSString, image: image)
                }
            }
        }
        else {
            StorageService.share.downloadImage(accountId: accountId, imageName: imageName) { (data, error) in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    messImageView.image = image
                    self.messageImageView.removeSpinnerView()
                    CacheService.share.setObject(key: "\(accountId)/\(imageName)" as NSString, image: image!)
                }
            }
        }
    }
    
    private func setUpAccountImage(accountId: String) {
        if let accountImage = CacheService.share.getObject(key: accountId as NSString) {
            accountImageView.image = accountImage
            return
        }
        accountImageView.image = nil
        let accImageView = UIImageView()
        accountImageView.addSubview(accImageView)
        accImageView.fillSuperView()
        StorageService.share.downloadImage(accountId: accountId, completion: { (data, error) in
            if error == nil && data != nil {
                let image = UIImage(data: data!)
                accImageView.image = image
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
                    self?.marginRightMessImageView.constant = -16.0
                }
                else {
                    self?.errorIcon.isHidden = false
                    self?.marginRightMessageView.constant = 10.0
                    self?.marginRightMessImageView.constant = 10.0
                }
                self?.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func tapButtonMessageImageView(_ sender: Any) {
        if let imageName = chatViewModel?.currentMessage?.imageName, let accountId = chatViewModel?.currentMessage?.accountId {
            let asset = (accountId: accountId, imageName: imageName)
            chatViewModel?.delegate?.didTapButtonMessageImageView(asset: asset)
        }
    }
    
}
