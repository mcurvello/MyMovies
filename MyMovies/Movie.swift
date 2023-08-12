//
//  Movie.swift
//  MyMovies
//
//  Created by Marcio Curvello on 12/08/23.
//

import Foundation

class Movie: Codable {
    var title: String
    var categories: String
    var duration: String
    var rating: Double
    var summary: String
    var image: String
}
