//
//  BookReview.swift
//  Rebit
//
//  Created by 홍정민 on 3/2/25.
//

import Foundation
import RealmSwift

struct BookReview: Hashable, Identifiable {
    var id: ObjectId
    var title: String
    var content: String
    var rating: Double
    var status: Int
    var isLike: Bool
    var year: Int
    var startDate: Date?
    var endDate: Date?
    var repeatCount: Int
    var saveDate: Date
}

extension BookReview {
    func toDTO() -> BookReviewDTO {
        return BookReviewDTO(
            title: self.title,
            content: self.content,
            rating: self.rating,
            status: self.status,
            year: self.year,
            startDate: self.startDate,
            endDate: self.endDate
        )
    }
}

extension BookReview {
    // 평점
    var ratingDescription: String {
        return status == 0 ? "" : rating.formatted()
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
