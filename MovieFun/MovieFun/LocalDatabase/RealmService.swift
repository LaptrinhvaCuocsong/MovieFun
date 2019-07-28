//
//  RealmService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class RealmService {
    
    static let share = RealmService()
    
    let realm = (UIApplication.shared.delegate as! AppDelegate).realm
    
    func addFavoriteMovie(movieId: Int, completion: ((Error?) -> Void)?) {
        let completion: ((Error?) -> Void) = completion ?? {_ in}
        let movieModel = MovieModel()
        movieModel.id = movieId
        do {
            try realm?.write {
                realm?.add(movieModel)
            }
            completion(nil)
        }
        catch {
            completion(error)
        }
    }
    
    func removeFavoriteMovie(movieId: Int, completion: ((Error?) -> Void)?) {
        let completion: ((Error?) -> Void) = completion ?? {_ in}
        let result = realm?.objects(MovieModel.self).filter("id == %d", movieId).first
        if let result = result {
            do {
                try realm?.write {
                    realm?.delete(result)
                }
                completion(nil)
            }
            catch {
                completion(error)
            }
        }
    }
    
    func checkFavoriteMovie(movieIds: [Int?]?, completion: (([Bool?]?, Error?) -> Void)?) {
        let completion: (([Bool?]?, Error?) -> Void) = completion ?? {_,_ in}
        var isFavoriteMovies: [Bool?]?
        if let movieIds = movieIds {
            isFavoriteMovies = [Bool?]()
            for movieId in movieIds {
                if let movieId = movieId {
                    isFavoriteMovies?.append(checkFavoriteMovie(movieId: movieId))
                }
                else {
                    isFavoriteMovies?.append(nil)
                }
            }
            completion(isFavoriteMovies, nil)
        }
        else {
            completion(nil, nil)
        }
    }
    
    private func checkFavoriteMovie(movieId: Int) -> Bool {
        let results = realm?.objects(MovieModel.self).filter("id == %d", movieId).first
        if results != nil {
            return true
        }
        return false
    }
    
}
