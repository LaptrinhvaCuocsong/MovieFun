//
//  NewMovieCellViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class NewMovieCellViewModel: NSObject, MovieListCellViewModel {
    
    var newMovies: DynamicType<[Movie]>?
    var currentIndex: DynamicType<Int>?
    
    init(newMovies: DynamicType<[Movie]>) {
        self.newMovies = newMovies
        currentIndex = DynamicType<Int>(value: 0)
    }
    
}

extension NewMovieCellViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMovieCollectionViewCell.cellIdentify, for: indexPath) as! NewMovieCollectionViewCell
        let movie = newMovies!.value![indexPath.section]
        cell.setContent(title: movie.title, voteAverage: movie.voteAverage, posterPath: movie.posterPath)
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.width
        return CGSize(width: width/4, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 2.5, bottom: 0.0, right: 2.5)
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.width
        currentIndex!.value = Int(Double(scrollView.contentOffset.x) / width)
    }
}
