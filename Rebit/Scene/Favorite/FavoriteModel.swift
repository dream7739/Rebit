//
//  FavoriteModel.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation

enum FavoriteContentState {
    case content(reviewList: [BookReviewContent])
    case updated(reviewList: [BookReviewContent])
    case noResult
}

protocol FavoriteModelStateProtocol: AnyObject {
    var contentState: FavoriteContentState { get }
    var placeholder: String { get }
}

protocol FavoriteModelActionProtocol: AnyObject {
    func displayNoResult()
    func displayInitial(reviewList: [BookReviewContent])
    func displayUpdated(reviewList: [BookReviewContent])
}

final class FavoriteModel: ObservableObject, FavoriteModelStateProtocol {
    @Published var contentState: FavoriteContentState = .noResult
    var placeholder = "favorite-empty".localized
}

extension FavoriteModel: FavoriteModelActionProtocol {
    func displayNoResult() {
        contentState = .noResult
    }
    
    func displayInitial(reviewList: [BookReviewContent]) {
        contentState = .content(reviewList: reviewList)
    }
    
    func displayUpdated(reviewList: [BookReviewContent]) {
        contentState = .updated(reviewList: reviewList)
    }
}
