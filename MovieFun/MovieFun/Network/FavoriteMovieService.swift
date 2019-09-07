//
//  FavoriteMovieService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FavoriteMovieService {
    
    static let share = FavoriteMovieService()
    
    private let db = Firestore.firestore()
    private let COLLECTION_NAME = "movie"
    private let SUB_COLLECTION_NAME = "favMovie"
    
    private let dispatchGroup = DispatchGroup()
    private var isFavorites = [Int:Bool?]()
    
    func addFavoriteMovie(movie: Movie, completion: ((Error?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            if let accountId = AccountService.share.getAccountId() {
                let movieId = "\(movie.id!)"
                let dictionary: [String: Any] = [
                    "id": movie.id!,
                    "vouteCount": movie.vouteCount ?? 0,
                    "voteAverage": movie.voteAverage ?? 0.0,
                    "title": movie.title ?? "",
                    "popularity": movie.popularity ?? 0.0,
                    "posterPath": movie.posterPath ?? "",
                    "originalLanguage": movie.originalLanguage ?? "",
                    "originalTitle": movie.originalTitle ?? "",
                    "genreIds": movie.genreIds ?? [Int](),
                    "backdropPath": movie.backdropPath ?? "",
                    "adult": movie.adult ?? false,
                    "overview": movie.overview ?? "",
                    "releaseDate": movie.releaseDate ?? Date()
                ]
                let documentRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME).document(movieId)
                documentRef.setData(dictionary, completion: completion)
            }
        }
        else {
            RealmService.share.addFavoriteMovie(movie: movie, completion: completion)
        }
    }
    
    func removeFavoriteMovie(movieId: Int, completion: ((Bool?, Error?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            let completion:((Bool?, Error?) -> Void) = completion ?? {_,_ in}
            if let accountId = AccountService.share.getAccountId() {
                let movieId = "\(movieId)"
                let documentRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME).document(movieId)
                documentRef.delete { (error) in
                    if error == nil {
                        completion(true, nil)
                    }
                    else {
                        completion(false, nil)
                    }
                }
            }
            else {
                completion(nil, nil)
            }
        }
        else {
            RealmService.share.removeFavoriteMovie(movieId: movieId, completion: completion)
        }
    }
    
    func checkFavoriteMovie(movieIds: [Int]?, completion: (([Int:Bool?]?, Error?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            let completion:(([Int:Bool?]?, Error?) -> Void) = completion ?? {_,_ in}
            if let movieIds = movieIds {
                if AccountService.share.getAccountId() != nil {
                    isFavorites.removeAll()
                    for movieId in movieIds {
                        dispatchGroup.enter()
                        checkFavoriteMovie(movieId: movieId) {[weak self] (isFavorite, error) in
                            self?.isFavorites[movieId] = isFavorite
                            self?.dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        completion(self.isFavorites, nil)
                    }
                }
                else {
                    completion(nil, nil)
                }
            }
            else {
                completion(nil, nil)
            }
        }
        else {
            RealmService.share.checkFavoriteMovie(movieIds: movieIds, completion: completion)
        }
    }
    
    func checkFavoriteMovie(movieId: Int, completion: ((Bool?, Error?) -> Void)?) {
        let completion:((Bool?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let movieId = "\(movieId)"
            let documentRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME).document(movieId)
            documentRef.getDocument(source: .default, completion: { (query, error) in
                if error == nil {
                    if query?.data() != nil {
                        completion(true, nil)
                    }
                    else {
                        completion(false, nil)
                    }
                }
                else {
                    completion(nil, error)
                }
            })
        }
        else {
            completion(nil, nil)
        }
    }
    
    func fetchFavoriteMovie(completion: (([Movie]?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            let completion:(([Movie]?) -> Void) = completion ?? {_ in}
            if let accountId = AccountService.share.getAccountId() {
                let documentRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME)
                documentRef.getDocuments(source: .default) { (query, error) in
                    if error == nil {
                        if let documents = query?.documents {
                            let movies = documents.map({ (document) -> Movie in
                                let data = document.data()
                                return self.getMovie(dictionary: data)
                            })
                            completion(movies)
                        }
                        else {
                            completion(nil)
                        }
                    }
                    else {
                        completion(nil)
                    }
                }
            }
            else {
                completion(nil)
            }
        }
        else {
            RealmService.share.fetchFavoriteMovie(completion: completion)
        }
    }
    
    func searchFavoriteMovie(searchText: String, completion: (([Movie]?) -> Void)?) {
        let isLogin = AccountService.share.isLogin()
        if isLogin {
            let completion:(([Movie]?) -> Void) = completion ?? {_ in}
            if let accountId = AccountService.share.getAccountId() {
                let documentRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME)
                documentRef.getDocuments(source: .default) {[weak self] (query, error) in
                    if error == nil {
                        if let documents = query?.documents {
                            var movies = [Movie]()
                            let searchText = "*\(searchText)*"
                            let predicate = NSPredicate(format: "SELF LIKE[c] %@", searchText)
                            for document in documents {
                                let movie = self?.getMovie(dictionary: document.data())
                                if let title = movie?.title {
                                    if predicate.evaluate(with: title) {
                                        movies.append(movie!)
                                    }
                                }
                            }
                            completion(movies)
                        }
                    }
                    else {
                        completion(nil)
                    }
                }
            }
            else {
                completion(nil)
            }
        }
        else {
            RealmService.share.searchFavoriteMovie(searchText: searchText, completion: completion)
        }
    }
    
    private func getMovie(dictionary: [String: Any]) -> Movie {
        let movie = Movie()
        movie.id = dictionary["id"] as? Int
        movie.vouteCount = dictionary["vouteCount"] as? Int
        movie.voteAverage = dictionary["voteAverage"] as? Double
        movie.title = dictionary["title"] as? String
        movie.popularity = dictionary["popularity"] as? Double
        movie.posterPath = dictionary["posterPath"] as? String
        movie.originalLanguage = dictionary["originalLanguage"] as? String
        movie.originalTitle = dictionary["originalTitle"] as? String
        movie.genreIds = dictionary["genreIds"] as? [Int]
        movie.backdropPath = dictionary["backdropPath"] as? String
        movie.adult = dictionary["adult"] as? Bool
        movie.overview = dictionary["overview"] as? String
        if let timeStamp = dictionary["releaseDate"] as? Timestamp {
            movie.releaseDate = timeStamp.dateValue()
        }
        return movie
    }
    
}
