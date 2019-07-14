//
//  FavoriteMovieViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class FavoriteMovieViewModel: NSObject {
    
    var sectionViewModels: DynamicType<[FavoriteSectionViewModel]>?
    var isFetching: DynamicType<Bool>?
    
    override init() {
        sectionViewModels = DynamicType<[FavoriteSectionViewModel]>(value: [FavoriteSectionViewModel]())
        isFetching = DynamicType<Bool>(value: false)
    }
    
}
