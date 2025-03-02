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
    func fetchReview(_ id: ObjectId) -> BookReviewDTO
    func fetchFavoriteReviewList() -> [BookReviewDTO]
    func fetchExpectedReviewList() -> [BookReviewDTO]
    
    // create
    func createReview( _ book: BookDTO, _ review: BookReviewDTO)
    
    // update
    func updateReview(_ id: ObjectId, _ newReview: BookReviewDTO)
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
    func fetchReview(_ id: ObjectId) -> BookReviewDTO {
        let review = realm.object(ofType: BookReviewDTO.self, forPrimaryKey: id) ?? BookReviewDTO()
        return review
    }
    
    func fetchFavoriteReviewList() -> [BookReviewDTO] {
        let list = realm.objects(BookReviewDTO.self)
            .filter { $0.isLike }
            .sorted { $0.saveDate > $1.saveDate }
            .map { $0 }
        return list
    }
    
    func fetchExpectedReviewList() -> [BookReviewDTO] {
        let list = realm.objects(BookReviewDTO.self)
            .filter { $0.status == 0 }
            .sorted { $0.saveDate > $1.saveDate }
            .map { $0 }
        return list
    }
    
    // create
    func createReview( _ book: BookDTO, _ review: BookReviewDTO) {
        do {
            try realm.write {
                book.reviewList.append(review)
            }
        } catch {
            print("add book review failed")
        }
    }
    
    // update
    func updateReview(_ id: ObjectId, _ newReview: BookReviewDTO) {
        guard let review = realm.object(ofType: BookReviewDTO.self, forPrimaryKey: id) else { return }
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
        guard let review = realm.object(ofType: BookReviewDTO.self, forPrimaryKey: id) else { return }
        
        do {
            try realm.write {
                review.isLike.toggle()
            }
        } catch {
            print("update like failed")
        }
    }
    
    func deleteReview(_ id: ObjectId) {
        guard let review = realm.object(ofType: BookReviewDTO.self, forPrimaryKey: id) else { return }
        
        do {
            try realm.write {
                realm.delete(review)
            }
        } catch {
            print("delete review failed")
        }
    }
}
