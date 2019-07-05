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
    private let DATE_FORMAT = "yyyy-mm-dd"
    private var newMovies: [Movie]?
    private var nowMovies: [Movie]?
    private var topRateMovies: [Movie]?
    private let dispatchGroup = DispatchGroup()
    private var haveError: Bool = false
    
    func fetchMovieList(completion: ()?) {
        dispatchGroup.enter()
        self.fetchMovie(url: NEW_MOVIE_URL, language: .en_US, page: 1) {[weak self] (movies, error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.newMovies = movies
            strongSelf.dispatchGroup.leave()
            strongSelf.haveError = error != nil ? true: strongSelf.haveError
        }
        dispatchGroup.enter()
        self.fetchMovie(url: NOW_MOVIE_URL, language: .en_US, page: 1) {[weak self] (movies, error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.nowMovies = movies
            strongSelf.dispatchGroup.leave()
            strongSelf.haveError = error != nil ? true: strongSelf.haveError
        }
        dispatchGroup.enter()
        self.fetchMovie(url: TOP_RATE_MOVIE_URL, language: .en_US, page: 1) {[weak self] (movies, error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.topRateMovies = movies
            strongSelf.dispatchGroup.leave()
            strongSelf.haveError = error != nil ? true: strongSelf.haveError
        }
        dispatchGroup.notify(queue: .main) {
            
        }
    }
    
    func fetchMovie(url: String, language: Language, page: Int, completion: (([Movie]?, Error?) -> Void)?) {
        let completion: (([Movie]?, Error?) -> Void) = completion ?? {_,_ in }
        do {
            let url = try String(format: url, Constants.API_KEY, language.rawValue, page).asURL()
            let dataRequest = Alamofire.request(url, method: .get)
            dataRequest.validate().responseJSON {[weak self] (dataResponse) in
                guard let strongSelf = self else {
                    return
                }
                if dataResponse.result.isSuccess {
                    let json = JSON(dataResponse)
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
            completion(nil, nil)
        }
    }
    
    func fetchTrailerMovie(movieId: String, language: Language, completion: (([Movie]?, Error?) -> Void)?) {
    }
    
    private func parseMovieJson(json: JSON) -> Movie {
        let movie = Movie()
        let movieJson = json.dictionaryValue
        movie.vouteCount = movieJson["vote_count"]?.int
        movie.id = movieJson["id"]?.string
        movie.video = movieJson["video"]?.bool
        movie.voteAverage = movieJson["vote_average"]?.double
        movie.title = movieJson["title"]?.string
        movie.popularity = movieJson["popularity"]?.double
        movie.posterPath = movieJson["poster_path"]?.string
        movie.originalLanguage = movieJson["original_language"]?.string
        movie.originalTitle = movieJson["original_title"]?.string
        movie.genreIds = movieJson["genre_ids"]?.arrayObject as? [String]
        movie.backdropPath = movieJson["backdrop_path"]?.string
        movie.adult = movieJson["adult"]?.bool
        movie.overview = movieJson["overview"]?.string
        movie.releaseDate = Utils.dateFromString(dateFormat: DATE_FORMAT, string: movieJson["release_date"]?.string)
        return movie
    }
}
