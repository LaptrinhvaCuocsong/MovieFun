//
//  FavoriteMovieViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class FavoriteMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let HEIGHT_OF_CELL = 200.0
    
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
        setLeftImageForSearchTextField()
        setFavoriteTableView()
        initBinding()
        controller.start()
        registerCell()
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            if !isFetching {
                self?.favoriteTableView.reloadData()
            }
        }
    }
    
    private func registerCell() {
        favoriteTableView.register(UINib(nibName: FavoriteTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FavoriteTableViewCell.cellIdentify)
    }
    
    private func setLeftImageForSearchTextField() {
        searchTextField.leftViewMode = .always
        let leftImageView = UIImageView(frame: CGRect(x: 10.0, y: 0.0, width: 20.0, height: searchTextField.height))
        leftImageView.image = UIImage(named: "search-32")
        leftImageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: searchTextField.height))
        view.addSubview(leftImageView)
        searchTextField.leftView = view
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellIdentify, for: indexPath) as! FavoriteTableViewCell
        cell.setUp(with: rowVM)
        cell.setContent(with: rowVM.favoriteMovie!.value!)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_CELL)
    }

}
