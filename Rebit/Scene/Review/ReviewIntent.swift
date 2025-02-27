//
//  ReviewIntent.swift
//  Rebit
//
//  Created by 홍정민 on 1/11/25.
//

import Foundation

protocol ReviewIntentProtocol: AnyObject {
    func viewOnAppear()
    func deleteReview(_ review: BookReview)
}

final class ReviewIntent: ReviewIntentProtocol {
    let model: ReviewModel
    let bookRepository: BookRepository
    let reviewRepository: ReviewRepository
    
    init(
        model: ReviewModel,
        bookRepository: BookRepository,
        reviewRepository: ReviewRepository
    ) {
        self.model = model
        self.bookRepository = bookRepository
        self.reviewRepository = reviewRepository
    }
    
    func viewOnAppear() {
        model.displayInitial()
    }
    
    func deleteReview(_ review: BookReview) {
        reviewRepository.deleteReview(review.id)
        
        if model.book.reviewList.isEmpty {
            model.displayNoReview()
        }
        
    }
    
}
