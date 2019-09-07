//
//  VideoListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD
import YoutubePlayer_in_WKWebView

class VideoListViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wkYoutubeView: WKYTPlayerView!
    
    var viewModel: VideoListViewModel {
        return controller.videoListViewModel!
    }
    
    lazy var controller: VideoListController = {
       return VideoListController()
    }()
    
    var movieId: String?
    
    static func createVideoListViewController(movieId: String) -> VideoListViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        let videoListVC = storyBoard.instantiateViewController(withIdentifier: "VideoListViewController") as! VideoListViewController
        videoListVC.movieId = movieId
        return videoListVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkYoutubeView.addSpinnerView()
        if let movieId = movieId {
            initBinding()
            viewModel.movieId = DynamicType<String>(value: movieId)
            controller.start()
        }
    }
    
    private func initBinding() {
        viewModel.title?.listener = {[weak self] (title) in
            self?.titleLabel.text = title
        }
        viewModel.key?.listener = {[weak self] (key) in
            self?.wkYoutubeView.load(withVideoId: key)
            self?.wkYoutubeView.removeSpinnerView()
        }
        viewModel.isFetching?.listener = {(isFetching) in
            if !isFetching {
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.isLoadFail?.listener = {[weak self] (isLoadFail) in
            if isLoadFail {
                self?.showAlertLoadFail()
            }
        }
    }
    
    private func showAlertLoadFail() {
        AlertService.share.showAlert(for: self, title: "Video is unavailable", message: nil, titleButton: "Back") {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

}
