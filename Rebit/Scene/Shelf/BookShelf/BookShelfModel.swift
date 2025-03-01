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

protocol BookShelfModelStateProtocol: AnyObject {
    var contentState: BookShelfContentState { get }
    var expectedReviewList: [BookReview] { get }
    var bookList: [BookInfo] { get }
    var placeholderText: String { get }
}

protocol BookShelfModelActionProtocol: AnyObject {
    func displayInitial(expectedReviewList: [BookReview], bookList: [BookInfo])
    func setContentState()
}

final class BookShelfModel: ObservableObject, BookShelfModelStateProtocol {
    private let bookDisplayLimit = 6

    @Published var contentState = BookShelfContentState()
    var expectedReviewList: [BookReview] = []
    var bookList: [BookInfo] = []
    var placeholderText = "shelf-my-empty".localized    
}

extension BookShelfModel: BookShelfModelActionProtocol {
    func displayInitial(expectedReviewList: [BookReview], bookList: [BookInfo]) {
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
