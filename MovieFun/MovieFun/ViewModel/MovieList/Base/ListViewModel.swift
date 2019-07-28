//
//  ListViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/22/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

protocol ListViewModelDelegate: class {
    
    func presentSpinner()
    
    func dismissSpinner()
    
}

class ListViewModel {
    
    var isPullToRefresh: DynamicType<Bool>?
    var isLoadMore: DynamicType<Bool>?
    var isFetching: DynamicType<Bool>?
    var listSectionViewModels: DynamicType<[ListSectionViewModel]>?
    var totalPage: Int = 1
    var currentPage: DynamicType<Int>?
    var url: String?
    weak var delegate: ListViewModelDelegate?
    
    init() {
        url = ""
        isPullToRefresh = DynamicType<Bool>(value: false)
        isLoadMore = DynamicType<Bool>(value: false)
        currentPage = DynamicType<Int>(value: 1)
        isFetching = DynamicType<Bool>(value: false)
        listSectionViewModels = DynamicType<[ListSectionViewModel]>(value: [ListSectionViewModel]())
    }
    
}

extension ListViewModel: ListRowViewModelDelegate {
    
    func presentSpinner() {
        delegate?.presentSpinner()
    }
    
    func dismissSpinner() {
        delegate?.dismissSpinner()
    }
    
}
