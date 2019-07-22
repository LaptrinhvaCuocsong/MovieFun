//
//  NewMovieListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/21/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewMovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var newMovieTableView: UITableView!
    
    private let HEIGHT_OF_CELL = 200.0
    private var needLoadMore = true
    private var isDidAppear = false
    
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
        navigationItem.title = "New movie list"
        navigationController?.hidesBarsOnSwipe = true
        registerCell()
        initBinding()
        controller.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFooterTableView()
        isDidAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        isDidAppear = false
    }
    
    private func setFooterTableView() {
        let loadingTableView = LoadingTableView.createLoadingTableView()
        newMovieTableView.tableFooterView = loadingTableView
    }
    
    private func initBinding() {
        viewModel.isLoadMore?.listener = {[weak self] (isLoadMore) in
            if !isLoadMore {
                self?.newMovieTableView.reloadData()
            }
        }
        viewModel.currentPage?.listener = {[weak self] (currentPage) in
            if currentPage >= self!.viewModel.totalPage {
                self?.newMovieTableView.tableFooterView = nil
                self?.needLoadMore = false
            }
        }
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.newMovieTableView.isHidden = false
                self?.newMovieTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                self?.newMovieTableView.isHidden = true
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
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isDidAppear {return}
        let y = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        if (y >= height - CGFloat(scrollView.height)) {
            if needLoadMore {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {[weak self] in
                    self?.controller.loadMore()
                }
            }
        }
    }

}
