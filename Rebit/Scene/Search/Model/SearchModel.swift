//
//  SearchModel.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Combine

enum SearchContentState {
    case initial
    case content(books: [Book])
    case noResult
}

protocol SearchModelActionProtocol: AnyObject {
    func displayInitial()
    func updateContent()
    func displayNoResult()
}

// State
final class SearchModel: ObservableObject {
    @Published var contentState: SearchContentState = .initial
    @Published var searchText = ""
    
    // Network
    var bookRequest = BookRequest(query: "")
    var page = 1
    var bookResponse = BookResponse(
        total: 0,
        start: 0,
        display: 0,
        items: []
    )
    
    // Text
    var placeholder = "search-empty".localized
    var noResults = "search-result-empty".localized
    
    // Scroll
    let scrollToTop = PassthroughSubject<Void, Never>()
}

// Action
extension SearchModel: SearchModelActionProtocol {
    func displayInitial() {
        contentState = .initial
    }
    
    func updateContent() {
        contentState = .content(books: bookResponse.items)
    }
    
    func displayNoResult() {
        contentState = .noResult
    }
}
