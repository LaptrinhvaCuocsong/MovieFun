//
//  FavoriteMovieService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class FavoriteMovieService {
    
    static let share = FavoriteMovieService()
    
    func addFavoriteMovie(movieId: Int, completion: ((Error?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            
        }
        else {
            RealmService.share.addFavoriteMovie(movieId: movieId, completion: completion)
        }
    }
    
    func removeFavoriteMovie(movieId: Int, completion: ((Error?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            
        }
        else {
            RealmService.share.removeFavoriteMovie(movieId: movieId, completion: completion)
        }
    }
    
    func checkFavoriteMovie(movieIds: [Int?]?, completion: (([Bool?]?, Error?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            
        }
        else {
            RealmService.share.checkFavoriteMovie(movieIds: movieIds, completion: completion)
        }
    }
    
}
