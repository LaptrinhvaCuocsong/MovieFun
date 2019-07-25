//
//  NowMovieListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NowMovieListViewController: ListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initViewModel() {
        controller = NowMovieListController()
        viewModel = controller?.listViewModel
    }
    
    override func setNavigationItem() {
        self.navigationItem.title = "Now movie list"
    }
    
    override func registerCell() {
        self.movieListTableView.register(UINib(nibName: NowMovieListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: NowMovieListTableViewCell.cellIdentify)
    }
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NowMovieListTableViewCell.cellIdentify, for: indexPath) as! NowMovieListTableViewCell
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
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
    
}
