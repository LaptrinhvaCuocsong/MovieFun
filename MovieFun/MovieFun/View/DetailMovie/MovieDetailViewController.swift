//
//  MovieDetailViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

enum STATE_OF_MOVIE {
    case IS_NOT_FAVORITE
    case IS_FAVORITE
}

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieDetailTableView: UITableView!
    
    var movieId: String?
    let kAddFavoriteTitle = "Add Favorite"
    let kRemoveFavoriteTitle = "Remove Favorite"
    
    var stateOfMovie: STATE_OF_MOVIE = .IS_NOT_FAVORITE {
        willSet {
            if newValue == .IS_FAVORITE {
                buttonAddToFavorite.title = kRemoveFavoriteTitle
            }
            else {
                buttonAddToFavorite.title = kAddFavoriteTitle
            }
        }
    }
    
    var viewModel: MovieDetailViewModel {
        get {
            return controller.movieDetailViewModel!
        }
    }

    lazy var controller: MovieDetailController = {
        return MovieDetailController()
    }()
    
    lazy var buttonAddToFavorite:UIBarButtonItem = {
        let btn = UIBarButtonItem(title: kAddFavoriteTitle, style: .plain, target: self, action: #selector(tappedButtonAddFavorite))
        return btn
    }()
    
    static func createMovieDetailViewController(with movieId: String) -> MovieDetailViewController {
        let storyBoard = UIStoryboard.init(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movieId = movieId
        return detailVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movie Detail"
        navigationItem.rightBarButtonItem = buttonAddToFavorite
        setMovieDetailTableView()
        registerCell()
        if let movieId = movieId {
            viewModel.movieId?.value = movieId
            viewModel.delegate = self
            initBinding()
            controller.start()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let firstSectionVM = viewModel.movieDetailSectionViewModels?.value?.first, let _ = firstSectionVM.movieDetailRowViewModels?.value?.first {
            let indexPath = IndexPath(row: 0, section: 0)
            movieDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.isFetching?.value = false
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                DispatchQueue.main.async {
                    self?.movieDetailTableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.movieId?.listener = {[weak self] (movieId) in
            self?.controller.start()
        }
        viewModel.isFavoriteMovie?.listener = {[weak self] (isFavorite) in
            if isFavorite {
                self?.stateOfMovie = .IS_FAVORITE
            }
            else {
                self?.stateOfMovie = .IS_NOT_FAVORITE
            }
        }
        viewModel.isLoadFail?.listener = {[weak self] (isLoadFail) in
            if isLoadFail {
                self?.navigationItem.rightBarButtonItem = nil
                self?.showAlertLoadFail()
            }
        }
        viewModel.addFavoriteSuccess?.listener = {[weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            if isSuccess {
                strongSelf.stateOfMovie = .IS_FAVORITE
                NotificationCenter.default.post(name: .ADD_FAVORITE_MOVIE_NOTIFICATION_KEY, object: nil)
            }
            else {
                AlertService.share.showAlert(for: strongSelf, title: nil, message: "Add Favorite Fail", titleButton: nil, action: nil)
            }
        }
        viewModel.removeFavoriteSuccess?.listener = {[weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            if isSuccess {
                strongSelf.stateOfMovie = .IS_NOT_FAVORITE
                NotificationCenter.default.post(name: .REMOVE_FAVORITE_MOVIE_NOTIFICATION_KEY, object: nil)
            }
            else {
                AlertService.share.showAlert(for: strongSelf, title: nil, message: "Add Favorite Fail", titleButton: nil, action: nil)
            }
        }
        viewModel.isChangeFavorite?.listener = { (isChangeFavorite) in
            if !isChangeFavorite {
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
    }
    
    private func showAlertLoadFail() {
        AlertService.share.showAlert(for: self, title: "Movie is unavailable", message: nil, titleButton: "Back") {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setMovieDetailTableView() {
        movieDetailTableView.separatorStyle = .none
        movieDetailTableView.separatorColor = .none
    }
    
    private func registerCell() {
        movieDetailTableView.register(UINib(nibName: MoviePlayerTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: MoviePlayerTableViewCell.cellIdentify)
        movieDetailTableView.register(UINib(nibName: ContentTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ContentTableViewCell.cellIdentify)
        movieDetailTableView.register(UINib(nibName: CastTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CastTableViewCell.cellIdentify)
        movieDetailTableView.register(UINib(nibName: CommentTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CommentTableViewCell.cellIdentify)
    }
    
    @objc private func tappedButtonAddFavorite() {
        if stateOfMovie == .IS_FAVORITE {
            controller.changeFavoriteMovie(false)
        }
        else {
            controller.changeFavoriteMovie(true)
        }
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y <= 0 {
            if let firstSectionVM = viewModel.movieDetailSectionViewModels?.value?.first, let firstRowVM = firstSectionVM.movieDetailRowViewModels?.value?.first as? MoviePlayerViewModel {
                firstRowVM.contentOffsetY?.value = Double(y)
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.movieDetailSectionViewModels!.value!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionVM = viewModel.movieDetailSectionViewModels!.value![section]
        return sectionVM.movieDetailRowViewModels!.value!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionVM = viewModel.movieDetailSectionViewModels!.value![indexPath.section]
        let rowVM = sectionVM.movieDetailRowViewModels!.value![indexPath.row]
        if let cellIdentify = controller.cellIdentify(with: rowVM) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
            if let cell = cell as? MovieDetailCell {
                cell.setUp(with: rowVM)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func pushToViewController(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func commentForMovie(movie: Movie) {
        if AccountService.share.isLogin() {
            let userInfo = [Constants.USER_INFO_MOVIE_KEY: movie]
            NotificationCenter.default.post(name: .PUSH_TO_COMMENT_LIST_NOTIFICATION_KEY, object: nil, userInfo: userInfo)
        }
        else {
            AlertService.share.showAlertRequestLogin(for: self) {
                if let tabBarController = self.tabBarController, let viewControllers = tabBarController.viewControllers {
                    let index = TabbarItem.account.rawValue
                    if viewControllers.count > index {
                        tabBarController.selectedIndex = index
                    }
                }
            }
        }
    }
    
}
