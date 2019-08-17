//
//  HeaderSectionChatTableView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/12/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class HeaderSectionChatTableView: UIView {
 
    @IBOutlet weak var timeLabel: UILabel!
    
    static func createHeaderSectionChatTableView() -> HeaderSectionChatTableView {
        let nib = UINib(nibName: "HeaderSectionChatTableView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil)[0] as! HeaderSectionChatTableView
    }
    
    func setContent(timeStr: String) {
        timeLabel.text = timeStr
    }
    
}
