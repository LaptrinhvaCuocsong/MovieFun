//
//  MainSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class MainSectionViewModel {
    
    var mainRowViewModels: DynamicType<[MainRowViewModel]>?
    
    init() {
        mainRowViewModels = DynamicType<[MainRowViewModel]>(value: [MainRowViewModel]())
    }
    
}
