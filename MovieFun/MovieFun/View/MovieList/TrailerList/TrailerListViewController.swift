//
//  TrailerListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TrailerListViewController: ListViewController {

    private let HEIGHT_OF_CELL = 250.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initViewModel() {
        controller = TrailerListController()
        viewModel = controller?.listViewModel
    }
    
    override func setNavigationItem() {
        self.navigationItem.title = "Trailer movie list"
    }
    
    override func registerCell() {
        self.movieListTableView.register(UINib(nibName: TrailerMovieListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TrailerMovieListTableViewCell.cellIdentify)
    }
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrailerMovieListTableViewCell.cellIdentify, for: indexPath) as! TrailerMovieListTableViewCell
        if let viewModel = viewModel {
            let sectionVM = viewModel.listSectionViewModels!.value![indexPath.section]
            let rowVM = sectionVM.listRowViewModels!.value![indexPath.row]
            cell.setUp(with: rowVM)
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = self.viewModel!.listSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.listRowViewModels!.value![indexPath.row]
        if let movie = rowVM.movie?.value, let movieId = movie.id {
            let videoListVC = VideoListViewController.createVideoListViewController(movieId: "\(movieId)")
            self.navigationController?.pushViewController(videoListVC, animated: true)
        }
    }

}
