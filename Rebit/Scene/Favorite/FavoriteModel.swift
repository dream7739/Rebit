//
//  FavoriteModel.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation

enum FavoriteContentState {
    case content(reviewList: [BookReview], bookList: [Book])
    case noResult
}

protocol FavoriteModelStateProtocol: AnyObject {
    var contentState: FavoriteContentState { get }
    var placeholder: String { get }
}

protocol FavoriteModelActionProtocol: AnyObject {
    func displayNoResult()
    func updateContent(reviewList: [BookReview], bookList: [Book])
}

final class FavoriteModel: ObservableObject, FavoriteModelStateProtocol {
    @Published var contentState: FavoriteContentState = .noResult
    var placeholder = "favorite-empty".localized
}

extension FavoriteModel: FavoriteModelActionProtocol {
    func displayNoResult() {
        contentState = .noResult
    }
    
    func updateContent(reviewList: [BookReview], bookList: [Book]) {
        contentState = .content(
            reviewList: reviewList,
            bookList: bookList
        )
    }
}
