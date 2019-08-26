//
//  Constants.swift
//  MovieFun
//
//  Created by nguyen manh hung on 6/27/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation

class Constants {
    static let API_KEY = "b437aba8c658e4a9673766fc9923250f"
    static let IMAGE_NOT_FOUND = "image-not-found"
    static let PUSH_TO_CHAT_VIEW_CONTROLLER = "PUSH_TO_CHAT_VIEW_CONTROLLER"
    static let USER_INFO_MOVIE_KEY = "movieId"
}

enum StoryBoardName: String {
    case MAIN = "Main"
    case UTILS = "Utils"
    case LOGIN = "Login"
}

enum Language: String {
    case en_US = "en_US"
}

enum ImageSize: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case original = "original"
}

enum TabbarItem: Int {
    case home = 0
    case favMovie = 1
    case commentList = 2
    case account = 3
}
