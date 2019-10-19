//
//  TopRateCellViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

protocol TopRateCellViewModelDelegate: class {
    
    func push(viewController: UIViewController, animated: Bool)
    
}

class TopRateCellViewModel: NSObject, MovieListCellViewModel {

    var topRateMovies: DynamicType<[Movie]>?
    var currentIndex: DynamicType<Int>?
    weak var delegate: TopRateCellViewModelDelegate?
    
    init(topRateMovies: DynamicType<[Movie]>) {
        self.topRateMovies = topRateMovies
        currentIndex = DynamicType<Int>(value: 0)
    }
    
}

extension TopRateCellViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRateCollectionViewCell.cellIdentify, for: indexPath) as! TopRateCollectionViewCell
        let movie = topRateMovies!.value![indexPath.section]
        cell.setContent(title: movie.title, overview: movie.overview, backdropPath: movie.backdropPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = topRateMovies!.value![indexPath.section]
        if let movieId = movie.id {
            let movieDetailVC = MovieDetailViewController.createMovieDetailViewController(with: "\(movieId)")
            delegate?.push(viewController: movieDetailVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.width
        currentIndex!.value = Int(Double(scrollView.contentOffset.x) / width)
    }
    
}
