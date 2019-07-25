//
//  TrailerMovieListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class TrailerMovieListViewModel: ListViewModel {
    
    override init() {
        super.init()
        listSectionViewModels = DynamicType<[ListSectionViewModel]>(value: [TrailerMovieListSectionViewModel]())
    }
    
}
