//
//  CommentViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/20/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol CommentViewModelDelegate:class {
    
    func commentForMovie(movieId: Int)
    
}

class CommentViewModel: MovieDetailRowViewModel {
    
    var movie: DynamicType<Movie>?
    weak var delegate: CommentViewModelDelegate?
    
}
