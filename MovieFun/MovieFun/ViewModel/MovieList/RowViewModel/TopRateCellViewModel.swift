//
//  TopRateCellViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/29/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class TopRateCellViewModel: NSObject, MovieListCellViewModel {

    var topRateMovies: DynamicType<[Movie]>?
    
    init(topRateMovies: DynamicType<[Movie]>) {
        self.topRateMovies = topRateMovies
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
    
}
