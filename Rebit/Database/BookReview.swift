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
}

final class BookReview: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var rating: Double
    @Persisted var status: String
    @Persisted var isLike: Bool
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
        status: String,
        isLike: Bool = false,
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
        self.startDate = startDate
        self.endDate = endDate
        self.saveDate = Date()
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
