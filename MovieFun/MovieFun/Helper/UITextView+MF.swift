//
//  UITextView+MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/8/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func setLineHeight(attribute: NSAttributedString, lineHeight: CGFloat) {
        let attr = NSMutableAttributedString(attributedString: attribute)
        let paramStyle = NSMutableParagraphStyle()
        paramStyle.minimumLineHeight = lineHeight
        paramStyle.maximumLineHeight = lineHeight
        attr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paramStyle, range: NSRange(location: 0, length: attr.length))
        self.attributedText = attr
    }
    
}
