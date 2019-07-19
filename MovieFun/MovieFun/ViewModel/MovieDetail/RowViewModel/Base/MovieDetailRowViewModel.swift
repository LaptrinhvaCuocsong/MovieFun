//
//  MovieDetailRowViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol MovieDetailRowViewModel {
    
    var movie: DynamicType<Movie>? {get set}
    
}
