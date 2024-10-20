//
//  Book.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation
import RealmSwift

final class BookInfo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var content: String
    @Persisted var author: String
    @Persisted var isbn: String
    @Persisted var pubdate: String
    @Persisted var publisher: String
    @Persisted var saveDate: Date
    @Persisted var reviewList = List<BookReview>()
    
    convenience init(
        title: String,
        content: String,
        author: String,
        isbn: String,
        pubdate: String,
        publisher: String,
        saveDate: Date = Date(),
        reviewList: List<BookReview> = List<BookReview>()
    ) {
        self.init()
        self.title = title
        self.content = content
        self.author = author
        self.isbn = isbn
        self.pubdate = pubdate
        self.publisher = publisher
    }
    
    var reviewCountDescription: String {
        return reviewList.count.formatted()
    }
    
}

final class BookReview: Object, ObjectKeyIdentifiable {
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
    var book: LinkingObjects<BookInfo>
    
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
    
    var ratingDescription: String {
        if status == 0 {
            return "-"
        } else {
            return rating.formatted()
        }
    }
    
    var startDateDescription: String {
        let start = DateFormatterManager.basicFormatter.string(from: startDate ?? Date())
        return start
    }
    
    var readingDateDescription: String {
        let start = DateFormatterManager.basicFormatter.string(from: startDate ?? Date())
        let end = DateFormatterManager.basicFormatter.string(from: endDate ?? Date())
        let description = start + " - " + end + " (\(periodDescription))"
        return description
    }
    
    var saveDateDescription: String {
        let date = DateFormatterManager.basicFormatter.string(from: saveDate)
        return date
    }
    
    var periodDescription: String {
        if let period = DateFormatterManager.dateCompare(startDate ?? Date(), endDate ?? Date()) {
            let realDate = period + 1
            return realDate.formatted() + "review-period".localized
        } else {
            return "-"
        }
    }
    
}

final class ReadingGoal: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var year: Int
    @Persisted var month: Int
    @Persisted var goal: Int
    @Persisted var saveDate: Date
    
    convenience init(
        year: Int,
        month: Int,
        goal: Int
    ) {
        self.init()
        self.year = year
        self.month = month
        self.goal = goal
        self.saveDate = Date()
        
    }
}
