//
//  DynamicType.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class DynamicType<T> {
    
    var value: T? {
        didSet {
            guard let listener = listener, let value = value else {
                return
            }
            listener(value)
        }
    }

    var listener: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
    func setListener(fireNow: Bool, action: ((T) -> Void)?) {
        listener = action
        guard let listener = listener, let value = value else {
            return
        }
        if fireNow {
            listener(value)
        }
    }
    
    func removeListener() {
        listener = nil
    }
}
