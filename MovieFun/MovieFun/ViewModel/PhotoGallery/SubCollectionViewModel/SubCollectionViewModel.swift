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
    var ratioIndex: DynamicType<CGFloat>?
    var subSectionViewModel: DynamicType<[SubSectionViewModel]>?
    private let widthCell: CGFloat = 150.0
    
    override init() {
        ratioIndex = DynamicType<CGFloat>(value: 0.0)
        subSectionViewModel = DynamicType<[SubSectionViewModel]>(value: [SubSectionViewModel]())
    }
    
    func reloadData() {
        subCollectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: currentAssetIndex)
        subCollectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    func scrollToPosition(with ratioIndex: CGFloat) {
        if let subCollectionView = self.subCollectionView {
            let assetIndex = ratioIndex * subCollectionView.contentSize.width / widthCell
            let indexPath = IndexPath(item: 0, section: Int(assetIndex))
            subCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
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
        return CGSize(width: widthCell, height: CGFloat(collectionView.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let offsetX = collectionView.contentOffset.x
        let x = offsetX / collectionView.contentSize.width
        self.ratioIndex?.value = x < 0 ? x * -1 : x
    }
    
}
