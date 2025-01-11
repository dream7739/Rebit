//
//  RealmRepository.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation
import RealmSwift

protocol BookRepository: AnyObject {
    func addBook(_ book: BookInfo)
    func addReview( _ book: BookInfo, _ review: BookReview)
    func fetchAll() -> Results<BookInfo>
    func deleteBook(_ id: ObjectId)
}

final class DefaultBookRepository: BookRepository {
    var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func addBook(_ book: BookInfo) {
        do {
            try realm.write {
                realm.add(book)
            }
        } catch {
            print("add book failed")
        }
    }
    
    func addReview( _ book: BookInfo, _ review: BookReview) {
        do {
            try realm.write {
                book.reviewList.append(review)
            }
        } catch {
            print("add book review failed")
        }
    }
    
    func fetchAll() -> Results<BookInfo> {
        let list = realm.objects(BookInfo.self)
        return list
    }
    
    func deleteBook(_ id: ObjectId) {
        guard let book = realm.object(ofType: BookInfo.self, forPrimaryKey: id) else { return }
        
        do {
            try realm.write {
                realm.delete(book)
            }
        } catch {
            print("delete book failed")
        }
    }
}

extension DefaultBookRepository {
    func isExistBook(title: String, isbn: String) -> Bool {
        let bookList = fetchAll()
        
        let existCount = bookList.where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.count
        
        return existCount >= 1
    }
    
    func getBookObject(title: String, isbn: String) -> BookInfo? {
        let bookList = fetchAll()

        let bookInfo = bookList.where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.first
        
        return bookInfo
    }
    
    func validateBook(_ id: ObjectId) -> Bool {
        guard let book = realm.object(ofType: BookInfo.self, forPrimaryKey: id) else { return false }
        let reviewCount = book.reviewList.count
        return reviewCount > 0 ? true : false
    }
}
