//
//  FavoriteMovieViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class FavoriteMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var marginTopTableView: NSLayoutConstraint!
    @IBOutlet weak var heightSearchBarView: NSLayoutConstraint!
    
    private let HEIGHT_OF_CELL = 200.0
    private let HEIGHT_OF_HEADER_CELL = 58.0
    
    var viewModel: FavoriteMovieViewModel {
        get {
            return controller.favoriteMovieViewModel!
        }
    }
    
    lazy var controller: FavoriteMovieController = {
        return FavoriteMovieController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setFavoriteTableView()
        viewModel.delegate = self
        initBinding()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                SVProgressHUD.dismiss()
                self?.favoriteTableView.reloadData()
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.isLoadFail?.listener = {[weak self] (isLoadFail) in
            if isLoadFail {
                self?.showAlertFetchingError()
            }
        }
        viewModel.isHiddenSearchBar?.listener = {[weak self] (isHiddenSearchBar) in
            if isHiddenSearchBar {
                self?.hiddenSearchBar(true)
            }
            else {
                self?.hiddenSearchBar(false)
            }
        }
    }
    
    private func hiddenSearchBar(_ isHidden: Bool) {
        if isHidden {
            searchBarView.isHidden = true
            marginTopTableView.constant = -1.0 * heightSearchBarView.constant
        }
        else {
            searchBarView.isHidden = false
            marginTopTableView.constant = 0.0
        }
        view.layoutIfNeeded()
    }
    
    private func showAlertFetchingError() {
        AlertService.share.showAlertError(for: self)
    }
    
    private func registerCell() {
        favoriteTableView.register(UINib(nibName: FavoriteTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FavoriteTableViewCell.cellIdentify)
        favoriteTableView.register(UINib(nibName: FavoriteHeaderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FavoriteHeaderTableViewCell.cellIdentify)
    }

    private func setFavoriteTableView() {
        favoriteTableView.separatorStyle = .none
        favoriteTableView.separatorColor = .clear
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels!.value!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = viewModel.sectionViewModels!.value![section]
        return sectionVM.rowViewModels!.value!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVM = viewModel.sectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.rowViewModels!.value![indexPath.row]
        if let cellIdentify = controller.cellIdentify(rowVM: rowVM) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
            if let cell = cell as? FavoriteCell {
                cell.setUp(with: rowVM)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionVM = viewModel.sectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.rowViewModels!.value![indexPath.row]
        if rowVM is FavoriteHeaderRowViewModel {
            return CGFloat(HEIGHT_OF_HEADER_CELL)
        }
        return CGFloat(HEIGHT_OF_CELL)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionVM = viewModel.sectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.rowViewModels!.value![indexPath.row]
        if let rowVM = rowVM as? FavoriteRowViewModel {
            if let movie = rowVM.favoriteMovie?.value, let movieId = movie.id {
                let detailMovieVC = MovieDetailViewController.createMovieDetailViewController(with: "\(movieId)")
                navigationController?.pushViewController(detailMovieVC, animated: true)
            }
        }
    }
    
}

extension FavoriteMovieViewController: FavoriteMovieViewModelDelegate {
    
    func removeFavoriteMovie() {
        controller.start()
        NotificationCenter.default.post(name: .REMOVE_FAVORITE_MOVIE_NOTIFICATION_KEY, object: nil, userInfo: nil)
    }
    
}

extension FavoriteMovieViewController: UISearchBarDelegate {
    
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
