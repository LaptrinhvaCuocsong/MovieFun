//
//  SubCollectionViewModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 9/19/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class SubCollectionViewModel: NSObject {
    
    weak var subCollectionView: UICollectionView?
    var currentAssetIndex: Int = 0
    var ratioIndex: DynamicType<Double>?
    var subSectionViewModel: DynamicType<[SubSectionViewModel]>?
    
    override init() {
        ratioIndex = DynamicType<Double>(value: 0.0)
        subSectionViewModel = DynamicType<[SubSectionViewModel]>(value: [SubSectionViewModel]())
    }
    
    func reloadData() {
        subCollectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: currentAssetIndex)
        subCollectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
}

extension SubCollectionViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionVM = subSectionViewModel?.value?.first
        return sectionVM?.subRowViewModels?.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCollectionViewCell.cellIdentify, for: indexPath) as! SubCollectionViewCell
        let sectionVM = subSectionViewModel!.value!.first!
        let rowVM = sectionVM.subRowViewModels!.value![indexPath.section]
        cell.setUp(with: rowVM)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: CGFloat(collectionView.height))
    }
    
}
