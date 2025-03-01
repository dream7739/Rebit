//
//  ReviewRepository.swift
//  Rebit
//
//  Created by 홍정민 on 1/10/25.
//

import Foundation
import RealmSwift

// ReviewRepository
protocol ReviewRepository: AnyObject {
    // fetch
    func fetchReview(_ id: ObjectId) -> BookReview
    func fetchFavoriteReviewList() -> [BookReview]
    func fetchExpectedReviewList() -> [BookReview]
    
    // create
    func createReview( _ book: BookInfo, _ review: BookReview)
    
    // update
    func updateReview(_ oldReview: BookReview, _ newReview: BookReview)
    func updateLike(_ id: ObjectId)
    
    // delete
    func deleteReview(_ id: ObjectId)
}

final class DefaultReviewRepository: ReviewRepository {
    var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    // fetch
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
    
    func fetchExpectedReviewList() -> [BookReview] {
        let list = realm.objects(BookReview.self)
            .filter { $0.status == 0 }
            .sorted { $0.saveDate > $1.saveDate }
            .map { $0 }
        return list
    }
    
    // create
    func createReview( _ book: BookInfo, _ review: BookReview) {
        do {
            try realm.write {
                book.reviewList.append(review)
            }
        } catch {
            print("add book review failed")
        }
    }
    
    // update
    func updateReview(_ oldReview: BookReview, _ newReview: BookReview) {
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
        guard let review = realm.object(ofType: BookReview.self, forPrimaryKey: id) else { return }
        
        do {
            try realm.write {
                review.isLike.toggle()
            }
        } catch {
            print("update like failed")
        }
    }
    
    func deleteReview(_ id: ObjectId) {
        guard let review = realm.object(ofType: BookReview.self, forPrimaryKey: id) else { return }
        
        do {
            try realm.write {
                realm.delete(review)
            }
        } catch {
            print("delete review failed")
        }
    }
}
