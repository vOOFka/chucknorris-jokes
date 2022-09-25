//
//  APIClient.swift
//  hw_lesson_5_preparing
//
//  Created by Home on 25.09.2022.
//

import Foundation
import Combine

enum Method {
    static let  baseURL = URL(string: "https://api.chucknorris.io/jokes")!
    
    case search(String)
    
    var url: URL {
        switch self {
        case .search(let query):
            let path = "/search?query="
            return URL(string: Method.baseURL.absoluteString + path + query)!
        }
    }
}

struct APIClient {
    let decoder = JSONDecoder()
    
    func getSearchResults(with query: String) -> AnyPublisher<SearchResult, CustomError> {
        URLSession.shared.dataTaskPublisher(for: Method.search(query).url)
            .retry(3)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: decoder)
            .mapError { error in
                error is URLError ? CustomError.networkError : .decodeError
            }
            .eraseToAnyPublisher()
    }
}
