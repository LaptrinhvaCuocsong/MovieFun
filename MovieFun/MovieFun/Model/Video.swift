//
//  Video.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/26/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

enum VideoType: String {
    case TEASER = "Teaser"
    case TRAILER = "Trailer"
}

class Video {

    var id: String?
    var iso6391: String?
    var iso31661: String?
    var key: String?
    var name: String?
    var site: String?
    var size: Int?
    var type: VideoType?
    
}
