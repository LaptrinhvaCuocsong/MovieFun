//
//  CacheService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/25/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class CacheService {
    
    static let share = CacheService()
    private let cache: NSCache<NSString, UIImage>!
    
    init() {
        cache = NSCache<NSString, UIImage>()
    }
    
    func setObject(key: NSString, image: UIImage) {
        cache.setObject(image, forKey: key)
    }
    
    func getObject(key: NSString) -> UIImage? {
        return cache.object(forKey: key)
    }
    
}
