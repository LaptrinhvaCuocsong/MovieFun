//
//  MovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MovieListViewModel {
    
    var isLoading: DynamicType<Bool>?
    var isHiddenMovieTableView: DynamicType<Bool>?
    var sectionViewModels: DynamicType<[MovieListSectionViewModel]>?
    
}
