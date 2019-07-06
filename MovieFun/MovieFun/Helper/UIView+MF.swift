//
//  UIView+MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/6/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

extension UIView {
    
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
