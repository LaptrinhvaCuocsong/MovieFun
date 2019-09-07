//
//  MoviePlayerViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol MoviePlayerViewModelDelegate: class {
    
    func pushToViewController(viewController: UIViewController, animated: Bool)
        
}

class MoviePlayerViewModel: MovieDetailRowViewModel {
    
    var movie: DynamicType<Movie>?
    var contentOffsetY: DynamicType<Double>?
    weak var delegate: MoviePlayerViewModelDelegate?
    
    init() {
        contentOffsetY = DynamicType<Double>(value: 0.0)
    }
    
}
