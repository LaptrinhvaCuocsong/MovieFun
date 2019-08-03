//
//  MovieModel.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/28/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import RealmSwift

class MovieModel: Object {
    
    @objc dynamic var vouteCount: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var video: Bool = false
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var posterPath: String = ""
    @objc dynamic var originalLanguage: String = ""
    @objc dynamic var originalTitle: String = ""
    dynamic var genreIds = List<Int>()
    @objc dynamic var backdropPath: String = ""
    @objc dynamic var adult: Bool = false
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: Date = Date()
    
}
