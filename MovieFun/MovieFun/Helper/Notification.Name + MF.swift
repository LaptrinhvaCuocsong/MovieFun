//
//  Notification.Name + MF.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/10/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    static let PUSH_TO_COMMENT_LIST_NOTIFICATION_KEY = NSNotification.Name("PUSH_TO_COMMENT_LIST_NOTIFICATION_KEY")
    static let COMMENT_TO_MOVIE_NOTIFICATION_KEY = NSNotification.Name("COMMENT_TO_MOVIE_NOTIFICATION_KEY")
    static let REMOVE_FAVORITE_MOVIE_NOTIFICATION_KEY = NSNotification.Name("REMOVE_FAVORITE_MOVIE_NOTIFICATION_KEY")
    static let ADD_FAVORITE_MOVIE_NOTIFICATION_KEY = NSNotification.Name("ADD_FAVORITE_MOVIE_NOTIFICATION_KEY")
    static let DID_REGISTER_SUCCESS_NOTIFICATION_KEY = NSNotification.Name("DID_REGISTER_SUCCESS_NOTIFICATION_KEY")
    static let DID_LOGIN_SUCCESS_NOTIFICATION_KEY = NSNotification.Name("DID_LOGIN_SUCCESS_NOTIFICATION_KEY")
    static let DID_LOGOUT_SUCCESS_NOTIFICATION_KEY = NSNotification.Name("DID_LOGOUT_SUCCESS_NOTIFICATION_KEY")
    
}
