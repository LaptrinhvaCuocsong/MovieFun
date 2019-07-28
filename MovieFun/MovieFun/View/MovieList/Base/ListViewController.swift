//
//  ListViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/22/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieListTableView: UITableView!
    
    private let HEIGHT_OF_CELL = 200.0
    private var needLoadMore = true
    private var isDidAppear = false
    var refreshControl: UIRefreshControl?
    var viewModel: ListViewModel?
    var controller: ListController?
    
    static func createListViewController() -> ListViewController {
        let storyBoard = UIStoryboard(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        let identifier = String(NSStringFromClass(self).split(separator: ".")[1])
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! ListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.viewModel?.delegate = self
        self.setNavigationItem()
        self.setRefreshControl()
        self.registerCell()
        self.initBinding()
        self.controller?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFooterTableView()
        isDidAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        isDidAppear = false
    }
    
    func initViewModel() {
        //Implement at child class
    }
    
    func setNavigationItem() {
        //Implement at child class
    }
    
    private func setRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white
        refreshControl?.addTarget(self, action: #selector(handlerRefreshControl), for: .valueChanged)
        movieListTableView.refreshControl = refreshControl
    }
    
    @objc private func handlerRefreshControl() {
        self.controller?.pullToRefresh(DispatchTime.now() + 1.0)
    }
    
    private func setFooterTableView() {
        let loadingTableView = LoadingTableView.createLoadingTableView()
        movieListTableView.tableFooterView = loadingTableView
    }
    
    private func initBinding() {
        self.viewModel?.isLoadMore?.listener = {[weak self] (isLoadMore) in
            if !isLoadMore {
                self?.movieListTableView.reloadData()
            }
        }
        self.viewModel?.currentPage?.listener = {[weak self] (currentPage) in
            if currentPage >= (self!.viewModel?.totalPage ?? currentPage) {
                self?.movieListTableView.tableFooterView = nil
                self?.needLoadMore = false
            }
            else {
                self?.needLoadMore = true
                self?.setFooterTableView()
            }
        }
        self.viewModel?.isPullToRefresh?.listener = {[weak self] (isPullToRefresh) in
            if !isPullToRefresh {
                self?.movieListTableView.reloadData()
                SVProgressHUD.dismiss()
                self?.refreshControl?.endRefreshing()
            }
            else {
                SVProgressHUD.show()
            }
        }
        self.viewModel?.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.movieListTableView.isHidden = false
                self?.movieListTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                self?.movieListTableView.isHidden = true
                SVProgressHUD.show()
            }
        }
    }
    
    func registerCell() {
        //Implement at child class
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.listSectionViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = self.viewModel?.listSectionViewModels!.value![section]
        return sectionVM?.listRowViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = self.viewModel?.listSectionViewModels?.value![indexPath.section]
        let rowVM = sectionVM?.listRowViewModels?.value![indexPath.row]
        let movie = rowVM?.movie?.value
        if let movieId = movie?.id {
            let detailVC = MovieDetailViewController.createMovieDetailViewController(with: "\(movieId)")
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isDidAppear {return}
        let y = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        if (y >= height - CGFloat(scrollView.height)) {
            if needLoadMore && !(self.viewModel?.isLoadMore?.value ?? true) {
                self.controller?.loadMore(DispatchTime.now() + 1.0)
            }
        }
    }

}

extension ListViewController: ListViewModelDelegate {
    
    func presentSpinner() {
        SVProgressHUD.show()
    }
    
    func dismissSpinner() {
        SVProgressHUD.dismiss()
    }
    
}
