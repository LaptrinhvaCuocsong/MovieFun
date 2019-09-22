//
//  PhotoGalleryViewController.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit
import Photos

class PhotoGalleryViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    
    var assets: [(accountId: String, imageName: String)]?
    var currectAsset: (accountId: String, imageName: String)?

    static func createPhotoGalleryNavigationController() -> (UINavigationController, PhotoGalleryViewController) {
        let storyBoard = UIStoryboard(name: StoryBoardName.UTILS.rawValue, bundle: nil)
        let photoGalleryNC = storyBoard.instantiateViewController(withIdentifier: "PhotoGalleryNavigationController") as! UINavigationController
        let photoGalleryVC = photoGalleryNC.viewControllers.first as! PhotoGalleryViewController
        return (photoGalleryNC, photoGalleryVC)
    }
    
    var viewModel: PhotoGalleryViewModel {
        get {
            return controller.photoGalleryVM!
        }
    }
    
    lazy var controller: PhotoGalleryController = {
        return PhotoGalleryController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.assets = assets
        viewModel.currentAsset = currectAsset
        mainCollectionView.delegate = viewModel.mainCollectionViewModel
        mainCollectionView.dataSource = viewModel.mainCollectionViewModel
        viewModel.mainCollectionViewModel?.mainCollectionView = mainCollectionView
        subCollectionView.delegate = viewModel.subCollectionViewModel
        subCollectionView.dataSource = viewModel.subCollectionViewModel
        viewModel.subCollectionViewModel?.subCollectionView = subCollectionView
        registerCell()
        initBinding()
        controller.start()
    }
    
    private func initBinding() {
        viewModel.isFetching?.listener = {[weak self] (isFetching) in
            DispatchQueue.main.async {
                if !isFetching {
                    self?.viewModel.subCollectionViewModel?.reloadData()
                    self?.viewModel.mainCollectionViewModel?.reloadData()
                }
            }
        }
    }
    
    private func registerCell() {
        mainCollectionView.register(UINib(nibName: MainCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MainCollectionViewCell.cellIdentify)
        subCollectionView.register(UINib(nibName: SubCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: SubCollectionViewCell.cellIdentify)
    }

    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
