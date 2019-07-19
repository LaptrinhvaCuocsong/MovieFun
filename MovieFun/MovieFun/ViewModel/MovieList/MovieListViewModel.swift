//
//  MovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListViewModelDelegate: class {
    
    func push(viewController: UIViewController, animated: Bool)
    
}

class MovieListViewModel {
    
    var isLoading: DynamicType<Bool>?
    var isHiddenMovieTableView: DynamicType<Bool>?
    var sectionViewModels: DynamicType<[MovieListSectionViewModel]>?
    
    weak var delegate: MovieListViewModelDelegate?
    
}

extension MovieListViewModel: NewMovieCellViewModelDelegate {
    
    func push(viewController: UIViewController, animated: Bool) {
        delegate?.push(viewController: viewController, animated: animated)
    }
    
}
