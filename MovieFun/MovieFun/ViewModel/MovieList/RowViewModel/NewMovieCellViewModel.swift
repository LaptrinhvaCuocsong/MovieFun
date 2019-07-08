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
    
    init(newMovies: DynamicType<[Movie]>) {
        self.newMovies = newMovies
    }
    
}

extension NewMovieCellViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
}
