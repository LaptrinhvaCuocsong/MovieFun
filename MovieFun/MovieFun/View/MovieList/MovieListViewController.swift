//
//  MovieListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieTableView: UITableView!
    
    var viewModel: MovieListViewModel {
        return controller.movieListViewModel!
    }
    
    lazy var controller: MovieListController = {
        return MovieListController(viewModel: MovieListViewModel())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Private method
    
    private func initBinding() {
        viewModel.isLoading = DynamicType<Bool>(value: false)
        viewModel.isLoading!.listener = {[weak self] isLoading in
            guard let strongSelf = self else {
                return
            }
            if isLoading {
                
            }
            else {
                
            }
        }
    }

    //MARK: - IBAction
    
    @IBAction func searchMovie(_ sender: Any) {
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
