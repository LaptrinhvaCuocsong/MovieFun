//
//  StorageService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/6/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class StorageService {
    
    static let share = StorageService()
    let storage = Storage.storage()
    
    func getData(image: UIImage) -> Data? {
        var data: Data?
        data = image.jpegData(compressionQuality: 0.75)
        if data == nil {
            data = image.pngData()
        }
        return data
    }
    
    func putImage(imageData: Data, completion: ((StorageMetadata?,Error?) -> Void)?) {
        let completion:((StorageMetadata?,Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let storageRef = storage.reference().child(accountId)
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                completion(metadata, error)
            }
        }
    }
    
    func downloadImage(completion: ((Data?, Error?) -> Void)?) {
        let completion:((Data?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let storageRef = storage.reference().child(accountId)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                completion(data, error)
            }
        }
    }
    
}
