//
//  LoadingViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    static let storyBoardIdentify: String = "LoadingViewController"
    
    static func createLoadingViewController() -> LoadingViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: storyBoardIdentify) as! LoadingViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spinner.stopAnimating()
    }

}
