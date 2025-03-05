//
//  EntireShelfModel.swift
//  Rebit
//
//  Created by 홍정민 on 3/5/25.
//

import Foundation

enum EntireShelfContentState {
    case initial(bookList: [Book])
    case result(bookList: [Book])
    case empty(placeholder: String)
}

protocol EntireShelfModelStateProtocol: AnyObject {
    var searchText: String { get set }
    var placeholder: String { get }
    var bookList: [Book] { get }
    var contentState: EntireShelfContentState { get }
}

protocol EntireShelfModelActionProtocol: AnyObject {
    func displayInitial(bookList: [Book])
    func displaySearchResult(bookList: [Book])
    func displayEmpty()
}


final class EntireShelfModel: ObservableObject, EntireShelfModelStateProtocol {
    @Published var searchText = ""
    @Published var contentState: EntireShelfContentState = .initial(bookList: [])
    var placeholder: String = "shelf-entire-empty".localized
    var bookList: [Book] = []
}


extension EntireShelfModel: EntireShelfModelActionProtocol {
    func displayInitial(bookList: [Book]) {
        self.bookList = bookList
        self.contentState = .initial(bookList: bookList)
    }

    func displayEmpty() {
        self.bookList = []
        self.contentState = .empty(placeholder: placeholder)
    }
    
    func displaySearchResult(bookList: [Book]) {
        self.bookList = bookList
        self.contentState = .result(bookList: bookList)
    }
}
