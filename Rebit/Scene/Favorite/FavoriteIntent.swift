//
//  FavoriteIntent.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation

protocol FavoriteIntentProtocol: AnyObject {
    func viewOnAppear()
}

final class FavoriteIntent: FavoriteIntentProtocol {
    let model: FavoriteModel
    let repository: ReviewRepository
    
    init(model: FavoriteModel, repository: ReviewRepository) {
        self.model = model
        self.repository = repository
    }
    
    func viewOnAppear() {
        let reviewDTOList = repository.fetchFavoriteReviewList()
        let bookDTOList = reviewDTOList.map { $0.book.first ?? BookDTO() }
        
        if reviewDTOList.isEmpty {
            model.displayNoResult()
        } else {
            let reviewList = reviewDTOList.map { $0.toBookReview() }
            let bookList = bookDTOList.map { $0.toBook() }
            model.updateContent(reviewList: reviewList, bookList: bookList)
        }
    }
    
}
