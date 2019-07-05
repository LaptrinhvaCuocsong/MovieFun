//
//  Utils.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/1/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class Utils {
    
    static func dateFromString(dateFormat: String, string: String?) -> Date? {
        guard let strDate = string else {
            return nil
        }
        let dateFm = DateFormatter()
        dateFm.dateFormat = dateFormat
        return dateFm.date(from: strDate)
    }
    
}
