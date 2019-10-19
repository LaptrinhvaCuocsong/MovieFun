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
    
    let heightOfFooterView: Double = 5.0
    
    var viewModel: MovieListViewModel {
        return controller.movieListViewModel!
    }
    
    lazy var controller: MovieListController = {
        return MovieListController(viewModel: MovieListViewModel())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        registerCell()
        viewModel.delegate = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.controller.start()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(pushToCommentList(notification:)), name: .PUSH_TO_COMMENT_LIST_NOTIFICATION_KEY, object: nil)
    }
    
    //MARK: - Private method
    
    @objc private func pushToCommentList(notification: Notification) {
        if let userInfo = notification.userInfo, let movie = userInfo[Constants.USER_INFO_MOVIE_KEY] as? Movie {
            if let tabBarController = self.tabBarController, let selectedVC = tabBarController.selectedViewController as? UINavigationController, let viewControllers = tabBarController.viewControllers {
                selectedVC.popToRootViewController(animated: false)
                selectedVC.dismiss(animated: true, completion: nil)
                let index = TabbarItem.commentList.rawValue
                if viewControllers.count > index {
                    tabBarController.selectedIndex = index
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        NotificationCenter.default.post(name: .COMMENT_TO_MOVIE_NOTIFICATION_KEY, object: nil, userInfo: [Constants.USER_INFO_MOVIE_KEY: movie])
                    }
                }
            }
        }
    }
    
    private func registerCell() {
        movieTableView.register(UINib(nibName: NowMovieTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: NowMovieTableViewCell.cellIdentify)
        movieTableView.register(UINib(nibName: NewMovieTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: NewMovieTableViewCell.cellIdentify)
        movieTableView.register(UINib(nibName: TopRateTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TopRateTableViewCell.cellIdentify)
        movieTableView.register(UINib(nibName: TrailersMovieTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TrailersMovieTableViewCell.cellIdentify)
    }
    
    private func initBinding() {
        viewModel.isLoading = DynamicType<Bool>(value: false)
        viewModel.isLoading!.listener = {[weak self] isLoading in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    let loadingVC = LoadingViewController.createLoadingViewController()
                    loadingVC.modalTransitionStyle = .crossDissolve
                    strongSelf.present(loadingVC, animated: true, completion: nil)
                }
                else {
                    strongSelf.dismiss(animated: true, completion: nil)
                    strongSelf.movieTableView.reloadData()
                }
            }
        }
        
        viewModel.isHiddenMovieTableView = DynamicType<Bool>(value: false)
        viewModel.isHiddenMovieTableView?.listener = {[weak self] isHidden in
            guard let strongSelf = self else {
                return
            }
            strongSelf.movieTableView.isHidden = isHidden
        }
        
        viewModel.sectionViewModels = DynamicType<[MovieListSectionViewModel]>(value: [MovieListSectionViewModel]())
        viewModel.sectionViewModels!.listener = {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.movieTableView.reloadData()
            }
        }
    }

    //MARK: - IBAction
    
    @IBAction func searchMovie(_ sender: Any) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: controller.cellIdentify(of: rowVM), for: indexPath)
        if let movieCell = cell as? MovieListCell {
            movieCell.setUp(with: rowVM)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(heightOfFooterView)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.width, height: heightOfFooterView))
        view.backgroundColor = .darkGray
        return view
    }
    
}

extension MovieListViewController: MovieListViewModelDelegate {
    
    func push(viewController: UIViewController, animated: Bool) {
        if let naviController = self.navigationController {
            naviController.pushViewController(viewController, animated: animated)
        }
    }
    
}
