//
//  Movie.swift
//  MoveSearch31
//
//  Created by Jon Corn on 1/24/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import Foundation

struct TopLevelDict: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let overview: String
    let poster: String?
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case poster = "poster_path"
        case rating = "vote_average"
    }
}
