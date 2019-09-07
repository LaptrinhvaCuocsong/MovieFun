//
//  LoginViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/2/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoginViewControllerDelegate: class {
    
    func dismissFromParent(viewController: UIViewController)
    
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginGoogleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    weak var delegate: LoginViewControllerDelegate?
    
    static func createLoginViewController() -> LoginViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.LOGIN.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    var viewModel: LoginViewModel {
        get {
            return controller.loginViewModel!
        }
    }
    
    lazy var controller: LoginController = {
        return LoginController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setLoginGoogleButton()
        initBinding()
    }
    
    //MARK: - Private method
    
    private func initBinding() {
        viewModel.isLoginSuccess?.listener = {[weak self] (isLoginSuccess) in
            guard let strongSelf = self else {
                return
            }
            if !isLoginSuccess {
                strongSelf.showAlertError(with: "Login fail")
            }
            else {
                NotificationCenter.default.post(name: .DID_LOGIN_SUCCESS_NOTIFICATION_KEY, object: nil)
                strongSelf.delegate?.dismissFromParent(viewController: strongSelf)
            }
        }
        viewModel.isRegisterSuccess?.listener = {[weak self] (isRegisterSuccess) in
            guard let strongSelf = self else {
                return
            }
            if !isRegisterSuccess {
                strongSelf.showAlertError(with: "Register fail")
            }
            else {
                NotificationCenter.default.post(name: .DID_REGISTER_SUCCESS_NOTIFICATION_KEY, object: nil)
                strongSelf.delegate?.dismissFromParent(viewController: strongSelf)
            }
        }
        viewModel.isLoading?.listener = {[weak self] (isLoading) in
            if !isLoading {
                self?.loginGoogleButton.isEnabled = true
                self?.loginButton.isEnabled = true
                self?.registerButton.isEnabled = true
                SVProgressHUD.dismiss()
            }
            else {
                self?.loginGoogleButton.isEnabled = false
                self?.loginButton.isEnabled = false
                self?.registerButton.isEnabled = false
                SVProgressHUD.show()
            }
        }
    }
    
    private func setLoginGoogleButton() {
        loginGoogleButton.layer.cornerRadius = CGFloat(loginGoogleButton.height / 2)
        loginGoogleButton.clipsToBounds = true
    }
    
    private func showAlertError(with message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - IBAction
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.isEmpty || password.isEmpty {
            showAlertError(with: "Email and password is required")
        }
        else {
            controller.login(email: email, password: password)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.isEmpty || password.isEmpty {
            showAlertError(with: "Email and password is required")
        }
        else {
            controller.register(email: email, password: password)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let y = textField.frame.origin.y
        loginScrollView.setContentOffset(CGPoint(x: 0.0, y: Double(y)), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
