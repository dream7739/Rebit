//
//  ReviewModel.swift
//  Rebit
//
//  Created by 홍정민 on 12/26/24.
//

import SwiftUI

enum ReviewContentState {
    case initial(reviewList: [BookReview])
}

protocol ReviewModelStateProtocol: AnyObject {
    var book: BookInfo { get }
    var reviewList: [BookReview] { get }
    var bookCover: UIImage { get }
    var contentState: ReviewContentState { get }
}

protocol ReviewModelActionProtocol: AnyObject {
    func displayInitial()
    func displayNoReview()
}

final class ReviewModel: ObservableObject, ReviewModelStateProtocol {
    var book: BookInfo
    var reviewList: [BookReview] = []
    var bookCover = UIImage()
    @Published var contentState: ReviewContentState
    @Environment(\.presentationMode) var presentationMode

    init(book: BookInfo) {
        self.book = book
        contentState = .initial(reviewList: reviewList)
    }
}

extension ReviewModel: ReviewModelActionProtocol {
    func displayInitial() {
        self.bookCover = ImageFileManager.shared.loadImageToDocument(filename: "\(book.id)") ?? UIImage()
        self.reviewList = book.reviewList.map { $0 }
        self.contentState = .initial(reviewList: reviewList)
    }
    
    func displayNoReview() {
        presentationMode.wrappedValue.dismiss()
    }
}
