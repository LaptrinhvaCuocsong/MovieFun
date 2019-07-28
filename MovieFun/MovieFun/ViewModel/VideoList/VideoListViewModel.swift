//
//  VideoListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/27/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class VideoListViewModel {
    
    var movieId: DynamicType<String>?
    var isFetching: DynamicType<Bool>?
    var key: DynamicType<String>?
    var title: DynamicType<String>?
    
    init() {
        title = DynamicType<String>(value: "")
        key = DynamicType<String>(value: "")
        isFetching = DynamicType<Bool>(value: false)
    }
    
}
