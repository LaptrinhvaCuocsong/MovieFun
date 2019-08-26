//
//  VideoListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class VideoListController {
    
    var videoListViewModel: VideoListViewModel?
    
    init() {
        videoListViewModel = VideoListViewModel()
    }
    
    func start() {
        videoListViewModel?.title?.value = ""
        videoListViewModel?.isFetching?.value = true
        if let movieId = videoListViewModel?.movieId?.value {
            MovieService.share.fetchVideo(movieId: movieId, languge: .en_US) {[weak self] (video) in
                if let video = video, let key = video.key, let title = video.name {
                    self?.videoListViewModel?.key?.value = key
                    self?.videoListViewModel?.title?.value = title
                }
                else {
                    self?.videoListViewModel?.isLoadFail?.value = true
                }
                self?.videoListViewModel?.isFetching?.value = false
            }
        }
    }
    
}
