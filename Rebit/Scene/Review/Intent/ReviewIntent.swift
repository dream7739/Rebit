//
//  ReviewIntent.swift
//  Rebit
//
//  Created by 홍정민 on 12/26/24.
//

import SwiftUI

protocol ReviewIntentProtocol: AnyObject {
    func viewOnAppear()
    func like(reviewID: String)
    func updateReview(review: BookReview)
    func deleteReview(review: BookReview)
}

final class ReviewIntent: ReviewIntentProtocol {
    private var model: ReviewModel
    private var repository: RealmRepository
    
    init(model: ReviewModel, repository: RealmRepository) {
        self.model = model
        self.repository = repository
    }
    
    func viewOnAppear() {
        let bookInfo = model.book
        
        let bookID = "\(bookInfo.id)"
        let reviewCount = bookInfo.reviewCountDescription
        let coverImage = ImageFileManager.shared.loadImageToDocument(filename: bookID) ?? UIImage()
        let title = bookInfo.title
        let author = bookInfo.author
        
        let review = Array(bookInfo.reviewList).map {
            return BookReviewPresentModel(
                coverImage: coverImage,
                bookTitle: title,
                author: author,
                status: ReadingStatus(rawValue: $0.status)!,
                rating: $0.ratingDescription,
                reviewCount: reviewCount,
                title: $0.title,
                content: $0.content,
                isLike: $0.isLike,
                readingDate: $0.readingDateDescription,
                expectedDate: $0.startDateDescription,
                saveDate: $0.saveDateDescription
            )
        }
        
        model.review = review
    }
    
    func like(reviewID: String) {
        
    }
    
    func updateReview(review: BookReview) {
        
    }
    
    func deleteReview(review: BookReview) {
        
    }
}
