//
//  BookShelfModel.swift
//  Rebit
//
//  Created by 홍정민 on 3/1/25.
//

import Foundation

struct BookShelfContentState {
    enum ExpectedStatus {
        case normal
        case empty
    }
    
    enum BookStatus {
        case normal
        case excess
        case empty
    }
    
    var expectedStatus: ExpectedStatus
    var bookStatus: BookStatus
    
    init() {
        self.expectedStatus = .normal
        self.bookStatus = .normal
    }
}

struct BookReviewContent: Hashable, Identifiable {
    let id = UUID()
    let book: Book
    let bookReview: BookReview
}

protocol BookShelfModelStateProtocol: AnyObject {
    var contentState: BookShelfContentState { get }
    var expectedReviewList: [BookReviewContent] { get }
    var bookList: [Book] { get }
    var placeholderText: String { get }
}

protocol BookShelfModelActionProtocol: AnyObject {
    func displayInitial(expectedReviewList: [BookReviewContent], bookList: [Book])
    func setContentState()
}

final class BookShelfModel: ObservableObject, BookShelfModelStateProtocol {
    private let bookDisplayLimit = 6

    @Published var contentState = BookShelfContentState()
    var expectedReviewList: [BookReviewContent] = []
    var bookList: [Book] = []
    var placeholderText = "shelf-my-empty".localized
}

extension BookShelfModel: BookShelfModelActionProtocol {
    func displayInitial(expectedReviewList: [BookReviewContent], bookList: [Book]) {
        self.expectedReviewList = expectedReviewList
        self.bookList = bookList
    }
    
    func setContentState() {
        var expectedStatus: BookShelfContentState.ExpectedStatus = .normal
        var bookStatus: BookShelfContentState.BookStatus = .normal
        
        if expectedReviewList.isEmpty {
            expectedStatus = .empty
        }
        
        if bookList.isEmpty {
            bookStatus = .empty
        } else if bookList.count >= 6 {
            bookStatus = .excess
        }
        
        contentState.expectedStatus = expectedStatus
        contentState.bookStatus = bookStatus
    }
    
}
