//
//  ListController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/23/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class ListController {
    
    var listViewModel: ListViewModel?
    
    init() {
        listViewModel = ListViewModel()
    }
    
    func start() {
        //Implement at child class
    }
    
    func pullToRefresh(_ dispatchTime: DispatchTime) {
        //Implement at child class
    }
    
    func loadMore(_ dispatchTime: DispatchTime) {
        //Implement at child class
    }
    
    func buildViewModel(totalPages: Int?, movies: [Movie]?) {
        //Implement at child class
    }
    
    func buildViewModelAfterLoadMore(totalPages: Int?, movies: [Movie]?) {
        //Implement at child class
    }
    
}
