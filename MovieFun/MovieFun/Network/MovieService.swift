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
import AlamofireImage

class MovieService {
    
    private let NEW_MOVIE_URL = "https://api.themoviedb.org/3/movie/upcoming?api_key=%@&language=%@&page=%d"
    private let NOW_MOVIE_URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=%@&language=%@&page=%d"
    private let TOP_RATE_MOVIE_URL = "https://api.themoviedb.org/3/movie/top_rated?api_key=%@&language=%@&page=%d"
    private let TRAILER_MOVIE_URL = "https://api.themoviedb.org/3/movie/%@/videos?api_key=%@&language=%@"
    private let POPULAR_MOVIE_URL = "https://api.themoviedb.org/3/movie/popular?api_key=%@&language=%@&page=%d"
    private let IMAGE_URL = "https://image.tmdb.org/t/p/%@/%@"
    private var newMovies: [Movie]?
    private var nowMovies: [Movie]?
    private var topRateMovies: [Movie]?
    private var popularMovies: [Movie]?
    private let dispatchGroup = DispatchGroup()
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
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
            completion(nil, nil)
        }
    }
    
    func fetchTrailerMovie(movieId: String, language: Language, completion: (([Movie]?, Error?) -> Void)?) {
    }
    
    func fetchImage(imageSize: PosterSize, imageName: String, completion: ((UIImage?) -> Void)?) {
        let completion: ((UIImage?) -> Void) = completion ?? {_ in}
        do {
            let url = try String(format: IMAGE_URL, imageSize.rawValue, imageName).asURL()
            if let image = self.cachedImage(for: url.absoluteString) {
                completion(image)
                return
            }
            Alamofire.request(url).responseImage {[weak self] (dataResponse) in
                if dataResponse.result.isSuccess {
                    if let image = dataResponse.result.value {
                        completion(image)
                        self?.cache(image: image, for: url.absoluteString)
                    }
                }
                else {
                    completion(nil)
                }
            }
        }
        catch {
            print(error)
            completion(nil)
        }
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
        movie.releaseDate = Utils.dateFromString(dateFormat: Utils.YYYY_MM_DD, string: movieJson["release_date"]?.string)
        return movie
    }
    
    //MARK: - Image Caching
    
    private func cache(image: UIImage, for identify: String) {
        self.imageCache.add(image, withIdentifier: identify)
    }
    
    private func cachedImage(for identify: String) -> UIImage? {
        return self.imageCache.image(withIdentifier: identify)
    }
}
