//
//  RealmRepository.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation
import RealmSwift

protocol BookRepository: AnyObject {
    func addBook(_ book: BookDTO)
    func fetchAll() -> Results<BookDTO>
    func deleteBook(_ id: ObjectId)
    
    // 책 존재 유무
    func isExistBook(title: String, isbn: String) -> Bool
    
    // 책 단건 조회
    func getBookObject(title: String, isbn: String) -> BookDTO?
}

final class DefaultBookRepository: BookRepository {
    var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func addBook(_ book: BookDTO) {
        do {
            try realm.write {
                realm.add(book)
            }
        } catch {
            print("add book failed")
        }
    }
    
    func fetchAll() -> Results<BookDTO> {
        let list = realm.objects(BookDTO.self)
        return list
    }
    
    func deleteBook(_ id: ObjectId) {
        guard let book = realm.object(ofType: BookDTO.self, forPrimaryKey: id) else { return }
        
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
        let existCount = realm.objects(BookDTO.self).where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.count
        
        return existCount >= 1
    }
    
    func getBookObject(title: String, isbn: String) -> BookDTO? {
        let bookList = fetchAll()

        let bookInfo = bookList.where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.first
        
        return bookInfo
    }
    
    func validateBook(_ id: ObjectId) -> Bool {
        guard let book = realm.object(ofType: BookDTO.self, forPrimaryKey: id) else { return false }
        let reviewCount = book.reviewList.count
        return reviewCount > 0 ? true : false
    }
}
