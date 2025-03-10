//
//  BookInfo.swift
//  Rebit
//
//  Created by 홍정민 on 1/10/25.
//

import Foundation
import RealmSwift

final class BookDTO: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var title: String
    @Persisted var content: String
    @Persisted var author: String
    @Persisted var isbn: String
    @Persisted var pubdate: String
    @Persisted var publisher: String
    @Persisted var saveDate: Date
    @Persisted var reviewList = List<BookReviewDTO>()
    
    convenience init(
        title: String,
        content: String,
        author: String,
        isbn: String,
        pubdate: String,
        publisher: String,
        saveDate: Date = Date(),
        reviewList: List<BookReviewDTO> = List<BookReviewDTO>()
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

extension BookDTO {
    func toBook() -> Book {
        return Book(
            id: self.id,
            title: self.title,
            content: self.content,
            author: self.author,
            isbn: self.isbn,
            publisher: self.publisher,
            pubdate: self.pubdate,
            saveDate: self.saveDate
        )
    }
}
