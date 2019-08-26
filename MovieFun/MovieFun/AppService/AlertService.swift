//
//  AlertService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/11/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    static let share = AlertService()
    
    func showAlertRequestLogin(for viewController: UIViewController, action: @escaping () -> Void) {
        let alertVC = UIAlertController(title: nil, message: "You need login to perform this function", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Login", style: .default, handler: { (_) in
            action()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertError(for viewController: UIViewController) {
        let alertVC = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlert(for viewController: UIViewController, title: String?, message: String?, titleButton: String?, action: (() -> Void)?) {
        let action: (() -> Void) = action ?? {}
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: titleButton ?? "OK", style: .default, handler: { (_) in
            action()
        }))
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
}
