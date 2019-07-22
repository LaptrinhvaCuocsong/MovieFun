//
//  LoadingTableView.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class LoadingTableView: UIView {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static let nibName = "LoadingTableView"
    
    static func createLoadingTableView() -> LoadingTableView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let loadingTableView = nib.instantiate(withOwner: self, options: nil)[0] as! LoadingTableView
        loadingTableView.spinner.hidesWhenStopped = true
        loadingTableView.spinner.startAnimating()
        return loadingTableView
    }
    
}
