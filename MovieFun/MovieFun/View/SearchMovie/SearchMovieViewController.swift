//
//  SearchMovieViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/31/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    let HEIGHT_OF_CELL = 200.0
    var isDidViewAppear = false
    var needLoadMore = true
    
    var viewModel: SearchMovieViewModel {
        get {
            return controller.searchMovieViewModel!
        }
    }
    
    lazy var controller: SearchMovieController = {
        return SearchMovieController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setFooterTableView()
        registerCell()
        viewModel.delegate = self
        initBinding()
        controller.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDidViewAppear = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        isDidViewAppear = false
    }

    private func setFooterTableView() {
        let loadingTableView = LoadingTableView.createLoadingTableView()
        movieTableView.tableFooterView = loadingTableView
    }
    
    private func registerCell() {
        movieTableView.register(UINib(nibName: SearchMovieTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: SearchMovieTableViewCell.cellIdentify)
    }
    
    private func initBinding() {
        viewModel.isLoadMore?.listener = {[weak self] (isLoadMore) in
            if !isLoadMore {
                self?.movieTableView.reloadData()
            }
        }
        viewModel.currentPage?.listener = {[weak self] (currentPage) in
            if currentPage >= (self?.viewModel.totalPage ?? currentPage) {
                self?.movieTableView.tableFooterView = nil
                self?.needLoadMore = false
            }
            else {
                self?.needLoadMore = true
                self?.setFooterTableView()
            }
        }
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.movieTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = viewModel.sectionViewModels!.value![section]
        return sectionVM.rowViewModels?.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVM = viewModel.sectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.rowViewModels!.value![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchMovieTableViewCell.cellIdentify, for: indexPath) as! SearchMovieTableViewCell
        cell.setUp(with: rowVM)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = viewModel.sectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.rowViewModels!.value![indexPath.row]
        if let movie = rowVM.movie?.value, let movieId = movie.id {
            let movieDetailVC = MovieDetailViewController.createMovieDetailViewController(with: "\(movieId)")
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isDidViewAppear {return}
        let y = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        if (y >= height - CGFloat(scrollView.height)) {
            if needLoadMore && !(viewModel.isLoadMore?.value ?? true) {
                controller.loadMore(DispatchTime.now() + 1.0)
            }
        }
    }
    
}

extension SearchMovieViewController: SearchMovieViewModelDelegate {
    
    func presentSpinner() {
        SVProgressHUD.show()
    }
    
    func dismissSpinner() {
        SVProgressHUD.dismiss()
    }
    
}

extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            controller.start()
        }
        else {
            controller.search(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        controller.start()
        searchBar.text = ""
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText == "" {
                controller.start()
            }
            else {
                controller.search(searchText: searchText)
            }
        }
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
}
