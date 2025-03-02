//
//  BookReview.swift
//  Rebit
//
//  Created by 홍정민 on 1/10/25.
//

import Foundation
import RealmSwift

final class BookReviewDTO: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var rating: Double
    @Persisted var status: Int
    @Persisted var isLike: Bool
    @Persisted(indexed: true) var year: Int
    @Persisted var startDate: Date?
    @Persisted(indexed: true) var endDate: Date?
    @Persisted var repeatCount: Int
    @Persisted var saveDate: Date
    
    @Persisted(originProperty: "reviewList")
    var book: LinkingObjects<BookDTO>
    
    convenience init(
        title: String,
        content: String,
        rating: Double,
        status: Int,
        isLike: Bool = false,
        year: Int,
        startDate: Date?,
        endDate: Date?
    ) {
        self.init()
        self.id = id
        self.title = title
        self.content = content
        self.rating = rating
        self.status = status
        self.isLike = isLike
        self.repeatCount = 1
        self.year = year
        self.startDate = startDate
        self.endDate = endDate
        self.saveDate = Date()
    }
    
    // 평점
    var ratingDescription: String {
        if status == 0 {
            return "-"
        } else {
            return rating.formatted()
        }
    }
    
    // 독서 시작일
    var startDateDescription: String {
        let start = DateFormatterManager.basicFormatter.string(from: startDate ?? Date())
        return start
    }
    
    // 독서 기간 24.12.12 - 24.12.15 (N일)
    var readingDateDescription: String {
        let start = DateFormatterManager.basicFormatter.string(from: startDate ?? Date())
        let end = DateFormatterManager.basicFormatter.string(from: endDate ?? Date())
        let description = start + " - " + end + " (\(periodDescription))"
        return description
    }
    
    // 리뷰 저장일
    var saveDateDescription: String {
        let date = DateFormatterManager.basicFormatter.string(from: saveDate)
        return date
    }
    
    // 독서 기간 (N일)
    var periodDescription: String {
        if let period = DateFormatterManager.dateCompare(startDate ?? Date(), endDate ?? Date()) {
            let realDate = period + 1
            return realDate.formatted() + "review-period".localized
        } else {
            return "-"
        }
    }
    
}

extension BookReviewDTO {
    func toBookReview() -> BookReview {
        return BookReview(
            id: self.id,
            title: self.title,
            content: self.content,
            rating: self.rating,
            status: self.status,
            isLike: self.isLike,
            year: self.year,
            startDate: self.startDate,
            endDate: self.endDate,
            repeatCount: self.repeatCount,
            saveDate: self.saveDate
        )
    }
}
