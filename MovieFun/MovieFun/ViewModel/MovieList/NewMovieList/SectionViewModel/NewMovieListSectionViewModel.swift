//
//  NewMovieListSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class NewMovieListSectionViewModel: ListSectionViewModel {
    
    override init() {
        super.init()
        listRowViewModels = DynamicType<[ListRowViewModel]>(value: [NewMovieListRowViewModel]())
    }
    
}
