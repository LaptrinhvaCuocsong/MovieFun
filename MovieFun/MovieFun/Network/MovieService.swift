//
//  MovieService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/30/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieService {
    
    private let NEW_MOVIE_URL = "https://api.themoviedb.org/3/movie/upcoming?api_key=%@&language=%@&page=%d"
    private let NOW_MOVIE_URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=%@&language=%@&page=%d"
    private let TOP_RATE_MOVIE_URL = "https://api.themoviedb.org/3/movie/top_rated?api_key=%@&language=%@&page=%d"
    private let TRAILER_MOVIE_URL = "https://api.themoviedb.org/3/movie/%@/videos?api_key=%@&language=%@"
    private let POPULAR_MOVIE_URL = "https://api.themoviedb.org/3/movie/popular?api_key=%@&language=%@&page=%d"
    private let MOVIE_DETAIL_URL = "https://api.themoviedb.org/3/movie/%@?api_key=%@&language=%@"
    private let MOVIE_CAST_URL = "https://api.themoviedb.org/3/movie/%@/credits?api_key=%@"
    private var newMovies: [Movie]?
    private var nowMovies: [Movie]?
    private var topRateMovies: [Movie]?
    private var popularMovies: [Movie]?
    private var movieDetail: Movie?
    private var movieDetailCast: [Cast]?
    
    private let dispatchGroup = DispatchGroup()
    
    static let share = MovieService()
    
    //MARK: - Movie Fetching
    
    func fetchMovieList(completion: (([Movie]?, [Movie]?, [Movie]?, [Movie]?) -> Void)?) {
        weak var weakSelf = self
        dispatchGroup.enter()
        self.fetchMovie(url: NEW_MOVIE_URL, language: .en_US, page: 1) { (movies, error) in
            weakSelf?.newMovies = movies
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchMovie(url: NOW_MOVIE_URL, language: .en_US, page: 1) { (movies, error) in
            weakSelf?.nowMovies = movies
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchMovie(url: TOP_RATE_MOVIE_URL, language: .en_US, page: 1) { (movies, error) in
            weakSelf?.topRateMovies = movies
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchMovie(url: POPULAR_MOVIE_URL, language: .en_US, page: 1) { (movies, error) in
            weakSelf?.popularMovies = movies
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            if let com = completion {
                com(weakSelf?.newMovies, weakSelf?.nowMovies, weakSelf?.topRateMovies, weakSelf?.popularMovies)
            }
        }
    }
    
    func fetchNewMovie(page: Int, language: Language, completion: (([Movie]?) -> Void)?) {
        let completion: (([Movie]?) -> Void) = completion ?? {_ in}
        self.fetchMovie(url: NEW_MOVIE_URL, language: language, page: page) { (movie, error) in
            if let _ = error {
                completion(nil)
            }
            else {
                completion(movie)
            }
        }
    }
    
    func fetchFavoriteMovie(completion: (([Movie]?) -> Void)?) {
        let completion:(([Movie]?) -> Void) = completion ?? {_ in}
        self.fetchMovie(url: TOP_RATE_MOVIE_URL, language: .en_US, page: 1) { (movies, error) in
            if error == nil {
                completion(movies)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func fetchMovieDetail(movieId: String, language: Language, completion: ((Movie?, [Cast]?) -> Void)?) {
        weak var weakSelf = self
        dispatchGroup.enter()
        fetchMovie(movieId: movieId, language: language) { (movie, error) in
            if error == nil {
                weakSelf?.movieDetail = movie
            }
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchMovieCast(movieId: movieId) { (casts, error) in
            if error == nil {
                weakSelf?.movieDetailCast = casts
            }
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            if completion != nil {
                completion!(weakSelf?.movieDetail, weakSelf?.movieDetailCast)
            }
        }
    }
    
    private func fetchMovie(url: String, language: Language, page: Int, completion: (([Movie]?, Error?) -> Void)?) {
        let completion: (([Movie]?, Error?) -> Void) = completion ?? {_,_ in }
        do {
            let url = try String(format: url, Constants.API_KEY, language.rawValue, page).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (dataResponse) in
                guard let strongSelf = self else {
                    return
                }
                if dataResponse.result.isSuccess {
                    guard let value = dataResponse.result.value else {
                        return
                    }
                    let json = JSON(value)
                    if let results = json["results"].array {
                        var movieList = [Movie]()
                        for item in results {
                            movieList.append(strongSelf.parseMovieJson(json: item))
                        }
                        completion(movieList, nil)
                    }
                    else {
                        completion(nil, nil)
                    }
                }
                else {
                    completion(nil, dataResponse.result.error)
                }
            }
        } catch {
            print(error)
            completion(nil, error)
        }
    }
    
    private func fetchMovie(movieId: String, language: Language, completion: ((Movie?, Error?) -> Void)?) {
        let completion: ((Movie?, Error?) -> Void) = completion ?? {_, _ in}
        do {
            let url = try String(format: MOVIE_DETAIL_URL, movieId, Constants.API_KEY, language.rawValue).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (response) in
                guard let strongSelf = self else {
                    return
                }
                if response.result.isSuccess {
                    guard let value = response.result.value else {
                        return
                    }
                    let json = JSON(value)
                    let movie = strongSelf.parseMovieJson(json: json)
                    completion(movie, nil)
                }
                else {
                    completion(nil, nil)
                }
            }
        }
        catch {
            print(error)
            completion(nil, error)
        }
    }
    
    private func fetchMovieCast(movieId: String, completion: (([Cast]?, Error?) -> Void)?) {
        let completion: (([Cast]?, Error?) -> Void) = completion ?? {_, _ in}
        do {
            let url = try String(format: MOVIE_CAST_URL, movieId, Constants.API_KEY).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (response) in
                guard let strongSelf = self else {
                    return
                }
                if response.result.isSuccess {
                    guard let value = response.result.value else {
                        return
                    }
                    let json = JSON(value)
                    if let results = json["cast"].array {
                        var casts = [Cast]()
                        for jsonItem in results {
                            casts.append(strongSelf.parseCast(json: jsonItem))
                        }
                        completion(casts, nil)
                    }
                }
                else {
                    completion(nil, nil)
                }
            }
        }
        catch {
            print(error)
            completion(nil, error)
        }
    }
    
    private func parseCast(json: JSON) -> Cast {
        let cast = Cast()
        let castJson = json.dictionaryValue
        cast.castId = castJson["cast_id"]?.int
        cast.character = castJson["character"]?.string
        cast.creditId = castJson["credit_id"]?.string
        cast.gender = castJson["gender"]?.int
        cast.name = castJson["name"]?.string
        cast.id = castJson["id"]?.int
        cast.order = castJson["order"]?.int
        cast.profilePath = castJson["profile_path"]?.string
        return cast
    }
    
    private func parseMovieJson(json: JSON) -> Movie {
        let movie = Movie()
        let movieJson = json.dictionaryValue
        movie.vouteCount = movieJson["vote_count"]?.int
        movie.id = movieJson["id"]?.int
        movie.video = movieJson["video"]?.bool
        movie.voteAverage = movieJson["vote_average"]?.double
        movie.title = movieJson["title"]?.string
        movie.popularity = movieJson["popularity"]?.double
        movie.posterPath = movieJson["poster_path"]?.string
        movie.originalLanguage = movieJson["original_language"]?.string
        movie.originalTitle = movieJson["original_title"]?.string
        movie.genreIds = movieJson["genre_ids"]?.arrayObject as? [Int]
        movie.backdropPath = movieJson["backdrop_path"]?.string
        movie.adult = movieJson["adult"]?.bool
        movie.overview = movieJson["overview"]?.string
        movie.releaseDate = Utils.dateFromString(dateFormat: Utils.YYYY_MM_DD, string: movieJson["release_date"]?.string)
        return movie
    }
    
}
