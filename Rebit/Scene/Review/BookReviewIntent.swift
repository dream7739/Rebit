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
    func updateReviewStatus(_ review: BookReview)
}

final class BookReviewIntent: BookReviewIntentProtocol {
    typealias BookReviewData = (book: BookDTO, reviewList: [BookReviewDTO])
    
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
        do {
            let bookCover = try fileManager.loadImageToDocument(filename: "\(model.book.id)")
            guard let bookReviewData: BookReviewData = fetchBookReviewData() else { return }
            let reviewList = bookReviewData.reviewList.map { $0.toBookReview() }
            model.displayInitial(bookCover: bookCover, reviewList: reviewList)
        } catch {
            print(error)
        }
    }
    
    func fetchBookReviewData() -> (BookDTO, [BookReviewDTO])? {
        guard let book = bookRepository.fetch(title: model.book.title, isbn: model.book.isbn) else { return nil }
        let reviewList: [BookReviewDTO] = book.reviewList.map { $0 }
        return (book, reviewList)
    }
    
    func deleteReviewClicked(_ review: BookReview) {
        reviewRepository.deleteReview(review.id)
        
        // 책, 리뷰정보 조회
        guard let bookReviewData: BookReviewData = fetchBookReviewData() else { return }
        
        if bookReviewData.reviewList.isEmpty {
            do {
                try fileManager.removeImageFromDocument(filename: "\(bookReviewData.book.id)")
                bookRepository.deleteBook(bookReviewData.book.id)
                model.dismissReview()
            } catch {
                print(error)
            }
        } else {
            let book = bookReviewData.book.toBook()
            let reviewList = bookReviewData.reviewList.map { $0.toBookReview() }
            model.updateBookReview(book: book, reviewList: reviewList)
        }
    }
    
    func isLikeClicked(_ review: BookReview) {
        reviewRepository.updateLike(review.id)
        updateReviewStatus(review)
    }
    
    func updateReviewStatus(_ review: BookReview) {
        guard let bookReviewData: BookReviewData = fetchBookReviewData() else { return }
        let book = bookReviewData.book.toBook()
        let reviewList = bookReviewData.reviewList.map { $0.toBookReview() }
        model.updateBookReview(book: book, reviewList: reviewList)
    }
}
