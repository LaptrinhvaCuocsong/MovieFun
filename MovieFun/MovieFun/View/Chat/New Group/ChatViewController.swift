//
//  ChatViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    static func createChatViewControlelr() -> ChatViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.MAIN.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
