//
//  NewMovieListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewMovieListViewController: ListViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newMovieTableView: UITableView!
    
    private let HEIGHT_OF_CELL = 200.0
    
    static func createNewMovieListViewController() -> NewMovieListViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "NewMovieListViewController") as! NewMovieListViewController
    }
    
    var viewModel: NewMovieListViewModel {
        return controller.newMovieListViewModel!
    }
    
    lazy var controller: NewMovieListController = {
        return NewMovieListController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        initBinding()
        controller.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.newMovieTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
    }
    
    private func registerCell() {
        newMovieTableView.register(UINib(nibName: NewMovieListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: NewMovieListTableViewCell.cellIdentify)
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.newMovieListSectionViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = viewModel.newMovieListSectionViewModels!.value![section]
        return sectionVM.newMovieListRowViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewMovieListTableViewCell.cellIdentify, for: indexPath) as! NewMovieListTableViewCell
        let sectionVM = viewModel.newMovieListSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.newMovieListRowViewModels!.value![indexPath.row]
        cell.setUp(with: rowVM)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }

}
