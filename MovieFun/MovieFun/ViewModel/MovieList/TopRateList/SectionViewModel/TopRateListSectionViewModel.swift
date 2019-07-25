//
//  TopRateListSectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/24/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class TopRateListSectionViewModel: ListSectionViewModel {
    
    override init() {
        super.init()
        listRowViewModels = DynamicType<[ListRowViewModel]>(value: [TopRateListRowViewModel]())
    }
    
}
