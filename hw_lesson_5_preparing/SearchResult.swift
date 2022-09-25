//
//  SearchResult.swift
//  hw_lesson_5_preparing
//
//  Created by Home on 25.09.2022.
//

import Foundation

struct SearchResult: Codable {
    var total: Int
    var result: [Joke?]
}
