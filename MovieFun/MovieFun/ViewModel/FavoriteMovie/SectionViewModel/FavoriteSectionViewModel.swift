//
//  FavoriteSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class FavoriteSectionViewModel: NSObject {
    
    var rowViewModels: DynamicType<[FavoriteBaseRowViewModel]>?
    
    override init() {
        rowViewModels = DynamicType<[FavoriteBaseRowViewModel]>(value: [FavoriteBaseRowViewModel]())
    }
    
}
