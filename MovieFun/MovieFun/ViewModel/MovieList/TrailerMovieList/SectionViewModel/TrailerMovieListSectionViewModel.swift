//
//  TrailerMovieListSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class TrailerMovieListSectionViewModel: ListSectionViewModel {
    
    override init() {
        super.init()
        listRowViewModels = DynamicType<[ListRowViewModel]>(value: [TrailerMovieListRowViewModel]())
    }
    
}
