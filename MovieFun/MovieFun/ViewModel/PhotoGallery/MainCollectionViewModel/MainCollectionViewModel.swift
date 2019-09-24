//
//  MainCollectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class MainCollectionViewModel: NSObject {
    
    weak var mainCollectionView: UICollectionView?
    var currentAssetIndex: Int = 0
    var ratioIndex: DynamicType<CGFloat>?
    var mainSectionViewModels: DynamicType<[MainSectionViewModel]>?
    
    override init() {
        ratioIndex = DynamicType<CGFloat>(value: 0.0)
        mainSectionViewModels = DynamicType<[MainSectionViewModel]>(value: [MainSectionViewModel]())
    }
 
    func reloadData() {
        mainCollectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: currentAssetIndex)
        mainCollectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    func scrollToPosition(with ratioIndex: CGFloat) {
        if let mainCollectionView = self.mainCollectionView {
            let assetIndex = ratioIndex * mainCollectionView.contentSize.width / mainCollectionView.frame.width
            let indexPath = IndexPath(item: 0, section: Int(assetIndex))
            mainCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
}

extension MainCollectionViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let x = offsetX / scrollView.contentSize.width
        self.ratioIndex?.value = x < 0 ? x * -1 : x
    }
    
}

extension MainCollectionViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionVM = mainSectionViewModels?.value?.first
        return sectionVM?.mainRowViewModels?.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.cellIdentify, for: indexPath) as! MainCollectionViewCell
        let sectionVM = mainSectionViewModels!.value!.first!
        let rowVM = sectionVM.mainRowViewModels!.value![indexPath.section]
        cell.setUp(with: rowVM)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.width), height: CGFloat(collectionView.height))
    }
    
}
