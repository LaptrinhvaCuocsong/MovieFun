//
//  ListSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/23/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class ListSectionViewModel {
    
    var listRowViewModels: DynamicType<[ListRowViewModel]>?
    
    init() {
        listRowViewModels = DynamicType<[ListRowViewModel]>(value: [ListRowViewModel]())
    }
    
}
