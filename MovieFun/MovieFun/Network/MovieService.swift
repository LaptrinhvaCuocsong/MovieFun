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
    
    static let NEW_MOVIE_URL = "https://api.themoviedb.org/3/movie/upcoming?api_key=%@&language=%@&page=%d"
    static let NOW_MOVIE_URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=%@&language=%@&page=%d"
    static let TOP_RATE_MOVIE_URL = "https://api.themoviedb.org/3/movie/top_rated?api_key=%@&language=%@&page=%d"
    static let TRAILER_MOVIE_URL = "https://api.themoviedb.org/3/movie/%@/videos?api_key=%@&language=%@"
    static let POPULAR_MOVIE_URL = "https://api.themoviedb.org/3/movie/popular?api_key=%@&language=%@&page=%d"
    static let MOVIE_DETAIL_URL = "https://api.themoviedb.org/3/movie/%@?api_key=%@&language=%@"
    static let MOVIE_CAST_URL = "https://api.themoviedb.org/3/movie/%@/credits?api_key=%@"
    static let VIDEO_MOVIE_URL = "https://api.themoviedb.org/3/movie/%@/videos?api_key=%@&language=%@"
    static let SEARCH_MOVIE_URL = "https://api.themoviedb.org/3/search/movie?api_key=%@&language=%@&query=%@&page=%d"
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
        self.fetchMovie(url: MovieService.NEW_MOVIE_URL, language: .en_US, page: 1) { (totalPages, movies, error) in
            if error == nil {
                weakSelf?.newMovies = movies
            }
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchMovie(url: MovieService.NOW_MOVIE_URL, language: .en_US, page: 1) { (totalPages, movies, error) in
            if error == nil {
                weakSelf?.nowMovies = movies
            }
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchMovie(url: MovieService.TOP_RATE_MOVIE_URL, language: .en_US, page: 1) { (totalPages, movies, error) in
            if error == nil {
                weakSelf?.topRateMovies = movies
            }
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        self.fetchMovie(url: MovieService.POPULAR_MOVIE_URL, language: .en_US, page: 1) { (totalPages, movies, error) in
            if error == nil {
                weakSelf?.popularMovies = movies
            }
            weakSelf?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            if let com = completion {
                com(weakSelf?.newMovies, weakSelf?.nowMovies, weakSelf?.topRateMovies, weakSelf?.popularMovies)
            }
        }
    }
    
    func fetchFavoriteMovie(completion: (([Movie]?) -> Void)?) {
        let completion:(([Movie]?) -> Void) = completion ?? {_ in}
        self.fetchMovie(url: MovieService.TOP_RATE_MOVIE_URL, language: .en_US, page: 1) { (totalPages, movies, error) in
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
    
    func fetchVideo(movieId: String, languge: Language, completion: ((Video?) -> Void)?) {
        let completion: ((Video?) -> Void) = completion ?? {_ in}
        fetchMovieVideo(movieId: movieId, language: languge) { (videos, error) in
            if error == nil && videos != nil {
                var trailerVideo: Video?
                for video in videos! {
                    if video.site == "YouTube" && video.type == VideoType.TRAILER {
                        trailerVideo = video
                        break
                    }
                }
                completion(trailerVideo)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func fetchMovie(url: String, language: Language, page: Int, completion: ((Int?, [Movie]?, Error?) -> Void)?) {
        let completion: ((Int?, [Movie]?, Error?) -> Void) = completion ?? {_,_,_ in }
        do {
            let url = try String(format: url, Constants.API_KEY, language.rawValue, page).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (dataResponse) in
                guard let strongSelf = self else {
                    completion(nil, nil, nil)
                    return
                }
                if dataResponse.result.isSuccess {
                    guard let value = dataResponse.result.value else {
                        completion(nil, nil, nil)
                        return
                    }
                    let json = JSON(value)
                    if let results = json["results"].array, let totalPages = json["total_pages"].int {
                        var movieList = [Movie]()
                        for item in results {
                            movieList.append(strongSelf.parseMovieJson(json: item))
                        }
                        completion(totalPages, movieList, nil)
                    }
                    else {
                        completion(nil, nil, nil)
                    }
                }
                else {
                    completion(nil, nil, dataResponse.result.error)
                }
            }
        } catch {
            print(error)
            completion(nil, nil, error)
        }
    }
    
    func searchMovie(searchText: String, page: Int, language: Language, completion: ((Int?, [Movie]?, Error?) -> Void)?) {
        let completion: ((Int?, [Movie]?, Error?) -> Void) = completion ?? {_,_,_ in}
        do {
            let url = try String(format: MovieService.SEARCH_MOVIE_URL, Constants.API_KEY, language.rawValue, searchText, page).asURL()
            let dataReq = Alamofire.request(url, method: .get)
            dataReq.responseJSON {[weak self] (dataResponse) in
                guard let strongSelf = self else {
                    completion(nil, nil, nil    )
                    return
                }
                if dataResponse.result.isSuccess {
                    if let value = dataResponse.result.value {
                        let json = JSON(value)
                        if let results = json["results"].array, let totalPage = json["total_pages"].int {
                            var movies = [Movie]()
                            for item in results {
                                movies.append(strongSelf.parseMovieJson(json: item))
                            }
                            completion(totalPage, movies, nil)
                        }
                    }
                    else {
                        completion(nil, nil, nil)
                    }
                }
                else {
                    completion(nil, nil, nil)
                }
            }
        }
        catch {
            print(error)
            completion(nil, nil, error)
        }
    }
    
    //MARK: - Private method
    
    private func fetchMovie(movieId: String, language: Language, completion: ((Movie?, Error?) -> Void)?) {
        let completion: ((Movie?, Error?) -> Void) = completion ?? {_, _ in}
        do {
            let url = try String(format: MovieService.MOVIE_DETAIL_URL, movieId, Constants.API_KEY, language.rawValue).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (response) in
                guard let strongSelf = self else {
                    completion(nil, nil)
                    return
                }
                if response.result.isSuccess {
                    guard let value = response.result.value else {
                        completion(nil, nil)
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
            let url = try String(format: MovieService.MOVIE_CAST_URL, movieId, Constants.API_KEY).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (response) in
                guard let strongSelf = self else {
                    completion(nil, nil)
                    return
                }
                if response.result.isSuccess {
                    guard let value = response.result.value else {
                        completion(nil, nil)
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
    
    private func fetchMovieVideo(movieId: String, language: Language, completion: (([Video]?, Error?) -> Void)?) {
        let completion: (([Video]?, Error?) -> Void) = completion ?? {_,_ in}
        do {
            let url = try String(format: MovieService.VIDEO_MOVIE_URL, movieId, Constants.API_KEY, language.rawValue).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.responseJSON {[weak self] (dataResponse) in
                guard let strongSelf = self else {
                    completion(nil, nil)
                    return
                }
                if dataResponse.result.isSuccess {
                    guard let value = dataResponse.result.value else {
                        completion(nil, nil)
                        return
                    }
                    let json = JSON(value)
                    if let results = json["results"].array {
                        var videos = [Video]()
                        for result in results {
                            videos.append(strongSelf.parseVideo(json: result))
                        }
                        completion(videos, nil)
                    }
                    else {
                        completion(nil, nil)
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
    
    private func parseVideo(json: JSON) -> Video {
        let video = Video()
        let videoJson = json.dictionaryValue
        video.id = videoJson["id"]?.string
        video.iso6391 = videoJson["iso_639_1"]?.string
        video.iso31661 = videoJson["iso_3166_1"]?.string
        video.key = videoJson["key"]?.string
        video.name = videoJson["name"]?.string
        video.site = videoJson["site"]?.string
        video.size = videoJson["size"]?.int
        video.type = Utils.videoTypeFromString(string: videoJson["type"]?.string)
        return video
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
        movie.releaseDate = Utils.share.dateFromString(dateFormat: Utils.YYYY_MM_DD, string: movieJson["release_date"]?.string)
        return movie
    }
    
}
