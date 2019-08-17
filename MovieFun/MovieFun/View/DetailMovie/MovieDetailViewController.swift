//
//  MovieDetailViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import SVProgressHUD

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieDetailTableView: UITableView!
    
    var movieId: String?
    
    var viewModel: MovieDetailViewModel {
        get {
            return controller.movieDetailViewModel!
        }
    }

    lazy var controller: MovieDetailController = {
        return MovieDetailController()
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
        setMovieDetailTableView()
        registerCell()
        if let movieId = movieId {
            viewModel.movieId?.value = movieId
            viewModel.delegate = self
            initBinding()
            controller.start()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.isFetching?.value = false
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.movieDetailTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else {
                SVProgressHUD.show()
            }
        }
        viewModel.movieId?.listener = {[weak self] (movieId) in
            self?.controller.start()
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
    
    func commentForMovie(movieId: Int) {
        if AccountService.share.isLogin() {
            if let tabBarController = self.tabBarController, let viewControllers = tabBarController.viewControllers {
                let index = TabbarItem.commentList.rawValue
                if viewControllers.count > index {
                    tabBarController.selectedIndex = index
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        NotificationCenter.default.post(name: .COMMENT_TO_MOVIE_NOTIFICATION_KEY, object: nil, userInfo: [Constants.USER_INFO_MOVIE_ID_KEY: movieId])
                    }
                }
            }
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
