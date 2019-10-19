//
//  Utils.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/1/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static let YYYY_MM_DD = "yyyy-MM-dd"
    static let YYYYMMDD = "yyyy/MM/dd"
    static let YYYY_MM_DD_HH_MM_SS = "yyyy/MM/dd hh:mm:ss"
    static let share = Utils()
    
    private let dateFm = DateFormatter()
    
    private init() {
        dateFm.locale = Locale.current
        dateFm.timeZone = TimeZone.current
    }
    
    func getFileName(from url: URL) -> String? {
        let urlStr = url.absoluteString as NSString
        let regex = "/\\w+.\\w+$"
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let results = regularExpression.matches(in: urlStr as String, range: NSRange(location: 0, length: urlStr.length))
            if let resultRange = results.last?.range {
                let range = NSRange(location: resultRange.location+1, length: resultRange.length-1)
                return urlStr.substring(with: range)
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func getCurrentDate() -> Date {
        let currentDate = Date()
        let dateStr = self.stringFromDate(dateFormat: Utils.YYYY_MM_DD_HH_MM_SS, date: currentDate)
        return self.dateFromString(dateFormat: Utils.YYYY_MM_DD_HH_MM_SS, string: dateStr!)!
    }
    
    func dateFromString(dateFormat: String, string: String?) -> Date? {
        guard let strDate = string else {
            return nil
        }
        dateFm.dateFormat = dateFormat
        return dateFm.date(from: strDate)
    }
    
    func stringFromDate(dateFormat: String, date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
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
    
    static func trim(_ str: String) -> String {
        return str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
}
