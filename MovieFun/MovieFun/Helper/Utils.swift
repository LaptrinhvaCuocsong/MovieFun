//
//  Utils.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/1/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class Utils {
    
    static let YYYY_MM_DD = "yyyy-mm-dd"
    
    static func dateFromString(dateFormat: String, string: String?) -> Date? {
        guard let strDate = string else {
            return nil
        }
        let dateFm = DateFormatter()
        dateFm.dateFormat = dateFormat
        return dateFm.date(from: strDate)
    }
    
    static func stringFromDate(dateFormat: String, date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let dateFm = DateFormatter()
        dateFm.dateFormat = dateFormat
        return dateFm.string(from: date)
    }
    
}
