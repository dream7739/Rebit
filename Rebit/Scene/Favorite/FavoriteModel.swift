//
//  FavoriteModel.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation

enum FavoriteContentState {
    case content(favorite: [BookReview])
    case noResult
}

protocol FavoriteModelStateProtocol {
    var contentState: FavoriteContentState { get }
    var placeholder: String { get }
}

protocol FavoriteModelActionProtocol: AnyObject {
    func displayNoResult()
    func updateContent(favorite: [BookReview])
}

final class FavoriteModel: ObservableObject, FavoriteModelStateProtocol {
    @Published var contentState: FavoriteContentState = .noResult
    var placeholder = "favorite-empty".localized
}

extension FavoriteModel: FavoriteModelActionProtocol {
    func displayNoResult() {
        contentState = .noResult
    }
    
    func updateContent(favorite: [BookReview]) {
        contentState = .content(favorite: favorite)
    }
}
