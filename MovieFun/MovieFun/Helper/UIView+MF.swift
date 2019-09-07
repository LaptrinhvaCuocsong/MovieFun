//
//  UIView+MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/6/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

extension UIView {
    
    func fillSuperView() {
        if let superView = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 0.0).isActive = true
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0.0).isActive = true
            self.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: 0.0).isActive = true
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0.0).isActive = true
        }
    }
    
    func addSpinnerView() {
        let spinnerView = SpinnerView()
        spinnerView.backgroundColor = .clear
        self.addSubview(spinnerView)
        spinnerView.fillSuperView()
        let spinner = UIActivityIndicatorView(style: .white)
        spinnerView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor, constant: 0.0).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor, constant: 0.0).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinnerView() {
        for subView in self.subviews {
            if subView is SpinnerView {
                subView.removeFromSuperview()
            }
        }
    }
    
    var top: Double {
        get {
            return Double(self.frame.origin.y)
        }
        set {
            self.frame.origin.y = CGFloat(newValue)
        }
    }
    
    var bottom: Double {
        get {
            return Double(self.frame.origin.y + self.frame.size.height)
        }
        set {
            self.frame.origin.y = CGFloat(newValue) - self.frame.size.height
        }
    }
    
    var left: Double {
        get  {
            return Double(self.frame.origin.x)
        }
        set {
            self.frame.origin.x = CGFloat(newValue)
        }
    }
    
    var right: Double {
        get {
            return Double(self.frame.origin.x + self.frame.size.width)
        }
        set {
            self.frame.origin.x = CGFloat(newValue) - self.frame.size.width
        }
    }
    
    var width: Double {
        get {
            return Double(self.frame.size.width)
        }
        set {
            self.frame.size.width = CGFloat(newValue)
        }
    }
    
    var height: Double {
        get {
            return Double(self.frame.size.height)
        }
        set {
            self.frame.size.height = CGFloat(newValue)
        }
    }
}
