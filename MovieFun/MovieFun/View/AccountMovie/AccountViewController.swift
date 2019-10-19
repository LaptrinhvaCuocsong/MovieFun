//
//  AccountViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var imagePickerController: UIImagePickerController?
    
    var viewModel: AccountViewModel {
        get {
            return controller.accountViewModel!
        }
    }
    
    lazy var controller: AccountController = {
       return AccountController(viewModel: AccountViewModel())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
        viewModel.delegate = self
        setImagePickerController()
        setAccountTableView()
        registerCell()
        initBinding()
        if !AccountService.share.isLogin() {
            addLoginViewController()
            return
        }
        else {
            controller.start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - Private method
    
    private func setImagePickerController() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.allowsEditing = true
    }
    
    private func addLoginViewController() {
        let loginVC = LoginViewController.createLoginViewController()
        loginVC.delegate = self
        addChild(loginVC)
        loginVC.view.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: view.height)
        view.addSubview(loginVC.view)
        didMove(toParent: self)
        logoutButton.isEnabled = false
    }
    
    private func initBinding() {
        viewModel.isUpdate?.listener = {[weak self] (isUpdate) in
            if !isUpdate {
                self?.showAlertError()
            }
            else {
                DispatchQueue.main.async {
                    self?.accountTableView.reloadData()
                }
            }
        }
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self?.accountTableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.accountImage?.listener = {[weak self] (image) in
            self?.accountImageView.image = image
        }
        viewModel.email?.listener = {[weak self] (email) in
            self?.emailLabel.text = email
        }
        viewModel.username?.listener = {[weak self] (username) in
            self?.usernameLabel.text = username
        }
        viewModel.logoutSuccess?.listener = {[weak self] (logoutSuccess) in
            if logoutSuccess {
                self?.accountImageView.image = UIImage(named: Constants.IMAGE_NOT_FOUND)
                NotificationCenter.default.post(name: .DID_LOGOUT_SUCCESS_NOTIFICATION_KEY, object: nil)
                SVProgressHUD.dismiss()
                self?.addLoginViewController()
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.haveChangeAccountInfo?.listener = {[weak self] (haveChange) in
            if haveChange {
                DispatchQueue.main.async {
                    self?.accountTableView.reloadData()
                }
            }
        }
    }
    
    private func showAlertError() {
        let alertVC = UIAlertController(title: "Error", message: "Update fail", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setAccountTableView() {
        accountTableView.delegate = viewModel
        accountTableView.dataSource = viewModel
        accountTableView.separatorColor = .none
    }
    
    private func registerCell() {
        accountTableView.register(UINib(nibName: UsernameTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UsernameTableViewCell.cellIdentify)
        accountTableView.register(UINib(nibName: EmailTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: EmailTableViewCell.cellIdentify)
        accountTableView.register(UINib(nibName: AddressTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: AddressTableViewCell.cellIdentify)
        accountTableView.register(UINib(nibName: DateOfBirthTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: DateOfBirthTableViewCell.cellIdentify)
    }
    
    private func setImageView() {
        accountImageView.layer.cornerRadius = CGFloat(accountImageView.width/2)
        accountImageView.clipsToBounds = true
    }
    
    private func showImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(self.imagePickerController!, animated: true, completion: nil)
        }
    }
    
    private func showAlertRequestOpenSetting() {
        let alertVC = UIAlertController(title: nil, message: "Go to settings to allow us to access your photo gallery", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Open Setting", style: .default, handler: { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization {[weak self] (status) in
            switch status {
            case .authorized:
                self?.showImagePickerController()
                break
            default:
                break
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func selectImage(_ sender: UIButton) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            showImagePickerController()
            break
        case .notDetermined:
            requestAuthorization()
            break
        case .restricted:
            fallthrough
        case .denied:
            showAlertRequestOpenSetting()
            break
        default:
            break
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        controller.logout(delay: 1.0)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            controller.uploadImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension AccountViewController: AccountViewModelDelegate {
    
    func present(viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }
    
    func updateUsername(username: String) {
        controller.updateUsername(username: username)
    }
    
    func updateAddress(address: String) {
        controller.updateAddress(address: address)
    }
    
    func updateDateOfBirth(date: Date) {
        controller.updateDateOfBirth(date: date)
    }
    
}

extension AccountViewController: LoginViewControllerDelegate {
    
    func dismissFromParent(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        controller.start()
        logoutButton.isEnabled = true
    }
    
}
