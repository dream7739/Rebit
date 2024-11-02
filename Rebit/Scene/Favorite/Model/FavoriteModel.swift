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

protocol FavoriteModelActionProtocol: AnyObject {
    func displayNoResult()
    func updateContent(favorite: [BookReview])
}

final class FavoriteModel: ObservableObject, FavoriteModelActionProtocol {
    @Published var contentState: FavoriteContentState = .noResult
    var placeholder = "favorite-empty".localized
    
    func displayNoResult() {
        contentState = .noResult
    }
    
    func updateContent(favorite: [BookReview]) {
        contentState = .content(favorite: favorite)
    }
}
