//
//  PresentImageViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 10/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class PresentImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var image: UIImage?
    
    static func createPresentImageViewController(with image: UIImage) -> PresentImageViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PresentImageViewController") as! PresentImageViewController
        vc.image = image
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        closeButton.layer.cornerRadius = 8.0
        closeButton.layer.borderWidth = 1.0
        closeButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let successImageView = UIImageView(image: UIImage(named: "icon_success"))
            view.addSubview(successImageView)
            let midX = view.frame.midX
            let midY = view.frame.midY
            successImageView.frame = CGRect(x: midX, y: midY, width: 0.0, height: 0.0)
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
                successImageView.frame = CGRect(x: midX-64.0, y: midY-64.0, width: 128.0, height: 128.0)
            }) { (_) in
                successImageView.removeFromSuperview()
            }
        }
        else {
            AlertService.share.showAlertError(for: self)
        }
    }
    
    @IBAction func downloadClicked(_ sender: Any) {
        if let image = self.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
