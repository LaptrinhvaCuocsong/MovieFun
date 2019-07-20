//
//  MovieDetailViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/17/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

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
        setMovieDetailTableView()
        registerCell()
        viewModel.movieId?.value = movieId
        initBinding()
        controller.start()
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.movieDetailTableView.reloadData()
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
