//
//  FavoriteIntent.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation

protocol FavoriteIntentProtocol: AnyObject {
    func viewOnAppear()
    func onChangeStatus()
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
        
        if reviewDTOList.isEmpty {
            model.displayNoResult()
        } else {
            let reviewList = reviewDTOList.map {
                BookReviewContent(
                    book: $0.book.first!.toBook(),
                    bookReview: $0.toBookReview()
                )
            }
            model.displayInitial(reviewList: reviewList)
        }
    }
    
    func onChangeStatus() {
        let reviewDTOList = repository.fetchFavoriteReviewList()
        
        if reviewDTOList.isEmpty {
            model.displayNoResult()
        } else {
            let reviewList = reviewDTOList.map {
                BookReviewContent(
                    book: $0.book.first!.toBook(),
                    bookReview: $0.toBookReview()
                )
            }
            model.displayUpdated(reviewList: reviewList)

        }
    }
}
