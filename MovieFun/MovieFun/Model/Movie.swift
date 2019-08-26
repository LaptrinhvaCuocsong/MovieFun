//
//  Movie.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class Movie {
    
    var vouteCount: Int?
    var id: Int?
    var video: Bool?
    var voteAverage: Double?
    var title: String?
    var popularity: Double?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var backdropPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: Date?
    
    static func getDictionary(from movie: Movie) -> [String: Any] {
        let movieInfo: [String: Any] = [
            "id": movie.id!,
            "vouteCount": movie.vouteCount ?? 0,
            "video": movie.video ?? false,
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
        return movieInfo
    }
    
    static func getMovie(from dictionary: [String: Any]?) -> Movie? {
        if let dictionary = dictionary {
            let movie = Movie()
            movie.vouteCount = dictionary["vouteCount"] as? Int
            movie.id = dictionary["id"] as? Int
            movie.video = dictionary["video"] as? Bool
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
            movie.releaseDate = dictionary["releaseDate"] as? Date
            return movie
        }
        return nil
    }
    
}
