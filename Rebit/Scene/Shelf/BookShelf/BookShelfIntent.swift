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
        let expectedReviewList = reviewRepository.fetchExpectedReviewList()
        let bookList: [BookInfo] = bookRepository.fetchAll().map { $0 }
        model.displayInitial(expectedReviewList: expectedReviewList, bookList: bookList)
        model.setContentState()
    }
    
    
}
