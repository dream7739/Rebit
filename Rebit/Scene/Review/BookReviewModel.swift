//
//  BookReviewModel.swift
//  Rebit
//
//  Created by 홍정민 on 12/26/24.
//

import SwiftUI
import Combine

enum BookReviewContentState {
    case initial(reviewList: [BookReview])
    case updated(reviewList: [BookReview])
}

protocol BookReviewModelStateProtocol: AnyObject {
    var book: Book { get }
    var reviewList: [BookReview] { get }
    var bookCover: UIImage { get }
    var contentState: BookReviewContentState { get }
    var dismissTrigger: PassthroughSubject<Void, Never> { get }
}

protocol BookReviewModelActionProtocol: AnyObject {
    func displayInitial(bookCover: UIImage, reviewList: [BookReview])
    func dismissReview()
    func updateBookReview(book: Book, reviewList: [BookReview])
}

final class BookReviewModel: ObservableObject, BookReviewModelStateProtocol {
    var book: Book
    var reviewList: [BookReview] = []
    var bookCover = UIImage()
    @Published var contentState: BookReviewContentState
    var dismissTrigger = PassthroughSubject<Void, Never>()

    init(book: Book) {
        self.book = book
        contentState = .initial(reviewList: reviewList)
    }
}

extension BookReviewModel: BookReviewModelActionProtocol {
    func displayInitial(bookCover: UIImage, reviewList: [BookReview]) {
        self.bookCover = bookCover
        self.reviewList = reviewList
        self.contentState = .initial(reviewList: reviewList)
    }
    
    // 리뷰 삭제 시 트리거 발생시키도록 구현
    func dismissReview() {
        dismissTrigger.send(())
    }
    
    func updateBookReview(book: Book, reviewList: [BookReview]) {
        self.book = book
        self.reviewList = reviewList
        contentState = .updated(reviewList: reviewList)
    }
    
}
