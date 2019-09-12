//
//  MFTextView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class MFTextView: UITextView {
    
    var placeholder: String? {
        didSet {
            addPlaceholder()
            self.delegate = self
        }
    }
    
    
    override var text: String! {
        didSet {
            if text == nil || text.isEmpty {
                addPlaceholder()
            }
            else {
                removePlaceholder()
            }
        }
    }
    
    var myDelegate: UITextViewDelegate?
    private var placeholderLabel: UILabel?
    
    private func addPlaceholder() {
        if let placeholderText = placeholder {
            placeholderLabel = UILabel()
            placeholderLabel?.text = placeholderText
            placeholderLabel?.font = UIFont.systemFont(ofSize: self.font!.pointSize, weight: .thin)
            placeholderLabel?.textColor = UIColor.lightGray
            placeholderLabel?.sizeToFit()
            self.addSubview(placeholderLabel!)
            let padding = self.textContainer.lineFragmentPadding
            let estimatedSize = placeholderLabel?.sizeThatFits(CGSize(width: self.frame.size.width-2.0*padding, height: self.frame.size.height))
            placeholderLabel?.frame = CGRect(x: padding, y: self.textContainerInset.top, width: placeholderLabel!.frame.size.width, height: estimatedSize!.height)
        }
    }
    
    private func removePlaceholder() {
        placeholderLabel?.removeFromSuperview()
    }
    
}

extension MFTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if !text.isEmpty {
                removePlaceholder()
            }
            else {
                addPlaceholder()
            }
        }
        myDelegate?.textViewDidChange?(textView)
    }
    
}
