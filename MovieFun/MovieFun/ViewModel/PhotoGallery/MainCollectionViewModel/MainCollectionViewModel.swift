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
    var ratioIndex: DynamicType<Double>?
    var mainSectionViewModels: DynamicType<[MainSectionViewModel]>?
    
    override init() {
        ratioIndex = DynamicType<Double>(value: 0.0)
        mainSectionViewModels = DynamicType<[MainSectionViewModel]>(value: [MainSectionViewModel]())
    }
 
    func reloadData() {
        mainCollectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: currentAssetIndex)
        mainCollectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
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
