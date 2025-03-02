//
//  SearchModel.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Combine

enum BookSearchContentState {
    case initial
    case content(books: [BookContentDTO])
    case noResult
}

protocol BookSearchModelStateProtocol: AnyObject {
    var contentState: BookSearchContentState { get }
    var searchText: String { get set }
    var bookList: [BookContentDTO] { get }
    var placeholder: String { get }
    var noResults: String { get }
    var scrollToTop: PassthroughSubject<Void, Never> { get }
}

protocol BookSearchModelActionProtocol: AnyObject {
    func displayInitial()
    func updateContent(books: [BookContentDTO])
    func displayNoResult()
}

final class BookSearchModel: ObservableObject, BookSearchModelStateProtocol {
    @Published var contentState: BookSearchContentState = .initial
    @Published var searchText = ""
    var bookList: [BookContentDTO] = []
    var placeholder = "search-empty".localized
    var noResults = "search-result-empty".localized
    var scrollToTop = PassthroughSubject<Void, Never>()
}

extension BookSearchModel: BookSearchModelActionProtocol {
    func displayInitial() {
        contentState = .initial
    }
    
    func updateContent(books: [BookContentDTO]) {
        contentState = .content(books: books)
    }
    
    func displayNoResult() {
        contentState = .noResult
    }
}
