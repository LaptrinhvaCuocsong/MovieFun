//
//  TrailersMovieCellViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

protocol TrailersMovieCellViewModelDelegate: class {
    
    func push(viewController: UIViewController, animated: Bool)
    
}

class TrailersMovieCellViewModel:NSObject, MovieListCellViewModel {
    
    var trailerMovies: DynamicType<[Movie]>?
    var currentIndex: DynamicType<Int>?
    weak var delegate: TrailersMovieCellViewModelDelegate?
    
    init(trailerMovies: DynamicType<[Movie]>) {
        self.trailerMovies = trailerMovies
        currentIndex = DynamicType<Int>(value: 0)
    }
    
}

extension TrailersMovieCellViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionViewCell.cellIdentify, for: indexPath) as! TrailerCollectionViewCell
        let movie = trailerMovies!.value![indexPath.section]
        cell.setContent(title: movie.title, backdropPath: movie.backdropPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = trailerMovies!.value![indexPath.section]
        //demo
        if let movieId = movie.id {
            let videoListVC = VideoListViewController.createVideoListViewController(movieId: "\(movieId)")
            delegate?.push(viewController: videoListVC, animated: true)
        }
        //push video view controller
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.width
        currentIndex!.value = Int(Double(scrollView.contentOffset.x) / width)
    }
    
}
