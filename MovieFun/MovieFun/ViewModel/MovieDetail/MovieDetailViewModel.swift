//
//  MovieDetailViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/18/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailViewModelDelegate: class {
    
    func pushToViewController(viewController: UIViewController, animated: Bool)
    
}

class MovieDetailViewModel {
    
    var isFetching: DynamicType<Bool>?
    var movieId: DynamicType<String>?
    var movieDetailSectionViewModels: DynamicType<[MovieDetailSectionViewModel]>?
    weak var delegate: MovieDetailViewModelDelegate?
    
    init() {
        isFetching = DynamicType<Bool>(value: false)
        movieId = DynamicType<String>(value: "")
        movieDetailSectionViewModels = DynamicType<[MovieDetailSectionViewModel]>(value: [MovieDetailSectionViewModel]())
    }
    
}

extension MovieDetailViewModel: MoviePlayerViewModelDelegate {
    
    func pushToViewController(viewController: UIViewController, animated: Bool) {
        self.delegate?.pushToViewController(viewController: viewController, animated: animated)
    }
    
}
