//
//  ReviewIntent.swift
//  Rebit
//
//  Created by 홍정민 on 1/11/25.
//

import Foundation
import UIKit

protocol BookReviewIntentProtocol: AnyObject {
    func viewOnAppear()
    func deleteReviewClicked(_ review: BookReview)
    func isLikeClicked(_ review: BookReview)
    func updateTrigger(_ review: BookReview)
}

final class BookReviewIntent: BookReviewIntentProtocol {
    let model: BookReviewModel
    let bookRepository: BookRepository
    let reviewRepository: ReviewRepository
    let fileManager: ImageFileManager
    
    init(
        model: BookReviewModel,
        bookRepository: BookRepository,
        reviewRepository: ReviewRepository,
        fileManager: ImageFileManager
    ) {
        self.model = model
        self.bookRepository = bookRepository
        self.reviewRepository = reviewRepository
        self.fileManager = fileManager
    }
    
    func viewOnAppear() {
        let bookCover = fileManager.loadImageToDocument(filename: "\(model.book.id)") ?? UIImage()
        let reviewList: [BookReview] = model.book.reviewList.map { $0 }
        model.displayInitial(bookCover: bookCover, reviewList: reviewList)
    }
    
    func deleteReviewClicked(_ review: BookReview) {
        reviewRepository.deleteReview(review.id)
        
        guard let bookReviewData = fetchUpdatedBookReviewData() else { return }
        model.updateBookReview(book: bookReviewData.0, reviewList: bookReviewData.1)
        
        if model.book.reviewList.isEmpty {
            fileManager.removeImageFromDocument(filename: "\(bookReviewData.0.id)")
            bookRepository.deleteBook(bookReviewData.0.id)
            model.dismissReview()
        }
    }
    
    func isLikeClicked(_ review: BookReview) {
        reviewRepository.updateLike(review.id)
        
        guard let bookReviewData = fetchUpdatedBookReviewData() else { return }
        model.updateBookReview(book: bookReviewData.0, reviewList: bookReviewData.1)
    }
    
    func updateTrigger(_ review: BookReview) {
        guard let bookReviewData = fetchUpdatedBookReviewData() else { return }
        model.updateBookReview(book: bookReviewData.0, reviewList: bookReviewData.1)
    }
    
    func fetchUpdatedBookReviewData() -> (BookInfo, [BookReview])? {
        guard let book = bookRepository.getBookObject(title: model.book.title, isbn: model.book.isbn) else { return nil }
        let reviewList: [BookReview] = book.reviewList.map { $0 }
        return (book, reviewList)
    }
}
