//
//  ReviewRepository.swift
//  Rebit
//
//  Created by 홍정민 on 1/10/25.
//

import Foundation
import RealmSwift

protocol ReviewRepository: AnyObject {
    func fetchReview(_ id: ObjectId) -> BookReview
    func fetchFavoriteReviewList() -> [BookReview]
    func updateBookReview(_ oldReview: BookReview, _ newReview: BookReview)
    func updateLike(_ id: ObjectId)
    func deleteReview(_ id: ObjectId)
}

final class DefaultReviewRepository: ReviewRepository {
    var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func fetchReview(_ id: ObjectId) -> BookReview {
        let review = realm.object(ofType: BookReview.self, forPrimaryKey: id) ?? BookReview()
        return review
    }
    
    func fetchFavoriteReviewList() -> [BookReview] {
        let list = realm.objects(BookReview.self)
            .filter { $0.isLike }
            .sorted { $0.saveDate > $1.saveDate }
            .map { $0 }
        return list
    }

    func updateBookReview(_ oldReview: BookReview, _ newReview: BookReview) {
        guard let review = realm.object(ofType: BookReview.self, forPrimaryKey: oldReview.id) else { return }
        
        do {
            try realm.write {
                review.title = newReview.title
                review.year = newReview.year
                review.startDate = newReview.startDate
                review.endDate = newReview.endDate
                review.rating = newReview.rating
                review.content = newReview.content
                review.status = newReview.status
            }
        } catch {
            print("update book failed")
        }
    }
    
    func updateLike(_ id: ObjectId) {
        let review = fetchReview(id)
        
        do {
            try realm.write {
                review.isLike.toggle()
            }
        } catch {
            print("update like failed")
        }
    }
    
    func deleteReview(_ id: ObjectId) {
        let review = fetchReview(id)
        
        do {
            try realm.write {
                realm.delete(review)
            }
        } catch {
            print("delete review failed")
        }
    }
}
