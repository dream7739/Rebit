//
//  BookShelfIntent.swift
//  Rebit
//
//  Created by 홍정민 on 3/1/25.
//

import Foundation

protocol BookShelfIntentProtocol: AnyObject {
    func viewOnAppear()
}

final class BookShelfIntent: BookShelfIntentProtocol {
    let model: BookShelfModel
    let bookRepository: BookRepository
    let reviewRepository: ReviewRepository
    
    init(model: BookShelfModel,
         bookRepository: BookRepository,
         reviewRepository: ReviewRepository) {
        self.model = model
        self.bookRepository = bookRepository
        self.reviewRepository = reviewRepository
    }
    
    func viewOnAppear() {
        let expectedReviewList = fetchExpectedReviewList()
        let bookList = fetchBookList()
        model.displayInitial(expectedReviewList: expectedReviewList, bookList: bookList)
        model.setContentState()
    }
    
    func fetchExpectedReviewList() -> [BookReviewContent] {
        let expectedReviewDTOList = reviewRepository.fetchExpectedReviewList()
        let expectedReviewList = expectedReviewDTOList.map {
            BookReviewContent(
                book: $0.book.first!.toBook(),
                bookReview: $0.toBookReview()
            )
        }
        return expectedReviewList
    }
    
    func fetchBookList() -> [Book] {
        let bookDTOList = bookRepository.fetchAll()
        let bookList: [Book] = bookDTOList.map { $0.toBook() }
        return bookList
    }
}
