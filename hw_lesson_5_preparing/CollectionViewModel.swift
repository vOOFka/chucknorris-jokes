//
//  CollectionViewModel.swift
//  hw_lesson_5_preparing
//
//  Created by Home on 25.09.2022.
//

import Foundation
import Combine

final public class CollectionViewModel: ObservableObject {
    private let apiClient = APIClient()
    private var subscriptions: [AnyCancellable] = []
    
    //input
    var searchQuery: String = "500"
    //output
    var output: PassthroughSubject<Output, Never> = .init()
    
    enum Input {
        case viewDidAppeare
        case sendSearchQuery(searchQuery: String)
    }
    
    enum Output {
        case searchQueryError(error: Error)
        case searchQuerySucceed(searchResults: SearchResult)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppeare:
                self?.handleGetSearchResults()
            case .sendSearchQuery(let searchQuery):
                self?.handleGetSearchResults(with: searchQuery)
            }
        }.store(in: &subscriptions)

        return output.eraseToAnyPublisher()
    }
    
    private func handleGetSearchResults(with searchQuery: String = "") {
        let searchQuery = (searchQuery.isEmpty) ? self.searchQuery : searchQuery
        apiClient.getSearchResults(with: searchQuery)
            .sink { [weak self] completion in
                switch completion {
                case.failure(let error):
                    self?.output.send(.searchQueryError(error: error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] searchResults in
                self?.output.send(.searchQuerySucceed(searchResults: searchResults))
            }
            .store(in: &subscriptions)
    }

    init() { }
}
