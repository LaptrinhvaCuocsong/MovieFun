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
    
    static func validateNumber(string: String?) -> Bool {
        guard let string = string else {
            return false
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", "\\d+")
        return predicate.evaluate(with: string)
    }
    
    static func videoTypeFromString(string: String?) -> VideoType? {
        if string == "Teaser" {
            return VideoType.TEASER
        }
        else if string == "Trailer" {
            return VideoType.TRAILER
        }
        else {
            return nil
        }
    }
    
}
