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
        
    func addFavoriteMovie(movie: Movie, completion: ((Error?) -> Void)?) {
        let completion: ((Error?) -> Void) = completion ?? {_ in}
        let movieModel = getMovieModel(from: movie)
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
    
    func removeFavoriteMovie(movieId: Int, completion: ((Bool?, Error?) -> Void)?) {
        let completion: ((Bool?, Error?) -> Void) = completion ?? {_,_ in}
        let result = realm?.objects(MovieModel.self).filter("id == %d", movieId).first
        if let result = result {
            do {
                try realm?.write {
                    realm?.delete(result)
                }
                completion(true, nil)
            }
            catch {
                completion(nil, error)
            }
        }
    }
    
    func checkFavoriteMovie(movieIds: [Int]?, completion: (([Int:Bool?]?, Error?) -> Void)?) {
        let completion: (([Int:Bool?]?, Error?) -> Void) = completion ?? {_,_ in}
        var isFavoriteMovies: [Int:Bool?]?
        if let movieIds = movieIds {
            isFavoriteMovies = [Int:Bool?]()
            for movieId in movieIds {
                isFavoriteMovies![movieId] = checkFavoriteMovie(movieId: movieId)
            }
            completion(isFavoriteMovies, nil)
        }
        else {
            completion(nil, nil)
        }
    }
    
    func searchFavoriteMovie(searchText: String, completion: (([Movie]?) -> Void)?) {
        let completion: (([Movie]?) -> Void) = completion ?? {_ in}
        let searchStr = "*\(searchText)*"
        let predicate = NSPredicate(format: "title LIKE[c] %@", searchStr)
        if let results = realm?.objects(MovieModel.self).filter(predicate) {
            let movieModels = [MovieModel](results)
            let movies = movieModels.map { (movieModel) -> Movie in
                return self.getMovie(from: movieModel)
            }
            completion(movies)
        }
        else {
            completion(nil)
        }
    }
    
    func fetchFavoriteMovie(completion: (([Movie]?) -> Void)?) {
        let completion: (([Movie]?) -> Void) = completion ?? {_ in}
        if let results = realm?.objects(MovieModel.self) {
            let movieModels = [MovieModel](results)
            let movies = movieModels.map { (movieModel) -> Movie in
                return self.getMovie(from: movieModel)
            }
            completion(movies)
        }
        else {
            completion(nil)
        }
    }
    
    private func checkFavoriteMovie(movieId: Int) -> Bool {
        let results = realm?.objects(MovieModel.self).filter("id == %d", movieId).first
        if results != nil {
            return true
        }
        return false
    }
    
    private func getMovieModel(from movie: Movie) -> MovieModel {
        let movieModel = MovieModel()
        movieModel.id = movie.id!
        movieModel.vouteCount = movie.vouteCount ?? 0
        movieModel.video = movie.video ?? false
        movieModel.voteAverage = movie.voteAverage ?? 0.0
        movieModel.title = movie.title ?? ""
        movieModel.popularity = movie.popularity ?? 0.0
        movieModel.posterPath = movie.posterPath ?? ""
        movieModel.originalLanguage = movie.originalLanguage ?? ""
        movieModel.originalTitle = movie.originalTitle ?? ""
        if let genreIds = movie.genreIds {
            movieModel.genreIds.append(objectsIn: genreIds)
        }
        movieModel.backdropPath = movie.backdropPath ?? ""
        movieModel.adult = movie.adult ?? false
        movieModel.overview = movie.overview ?? ""
        movieModel.releaseDate = movie.releaseDate ?? Date()
        return movieModel
    }
    
    func getMovie(from movieModel: MovieModel) -> Movie {
        let movie = Movie()
        movie.id = movieModel.id
        movie.vouteCount = movieModel.vouteCount
        movie.video = movieModel.video
        movie.voteAverage = movieModel.voteAverage
        movie.title = movieModel.title
        movie.popularity = movieModel.popularity
        movie.posterPath = movieModel.posterPath
        movie.originalLanguage = movieModel.originalLanguage
        movie.originalTitle = movieModel.originalTitle
        movie.genreIds = [Int](movieModel.genreIds)
        movie.backdropPath = movieModel.backdropPath
        movie.adult = movieModel.adult
        movie.overview = movieModel.overview
        movie.releaseDate = movieModel.releaseDate
        return movie
    }
    
}
