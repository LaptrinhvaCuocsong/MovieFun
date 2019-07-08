//
//  UInt64+MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/8/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}
