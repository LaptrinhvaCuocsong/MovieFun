//
//  NowMovieCellViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol NowMovieCellViewModelDelegate: class {
    
    func push(viewController: UIViewController, animated: Bool)
    
}

class NowMovieCellViewModel: MovieListCellViewModel {
    
    var nowMovies: DynamicType<[Movie]>?
    weak var delegate: NowMovieCellViewModelDelegate?
    
    init(nowMovies: DynamicType<[Movie]>) {
        self.nowMovies = nowMovies
    }
    
}
