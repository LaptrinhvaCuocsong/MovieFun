//
//  UILabel+MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/27/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setAttributeText(text: String, lineHeight: Int) {
        let attributeStr = NSMutableAttributedString(string: text)
        let paramStyle = NSMutableParagraphStyle()
        paramStyle.minimumLineHeight = CGFloat(lineHeight)
        paramStyle.maximumLineHeight = CGFloat(lineHeight)
        attributeStr.addAttribute(.paragraphStyle, value: paramStyle, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributeStr
    }
    
}
