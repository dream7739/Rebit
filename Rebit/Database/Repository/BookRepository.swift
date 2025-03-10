//
//  RealmRepository.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation
import RealmSwift

protocol BookRepository: AnyObject {
    // create
    func createBook(_ book: BookDTO)
    
    // fetch
    func fetchAll() -> Results<BookDTO>
    func fetch(keyword: String) -> Results<BookDTO>
    func fetch(title: String, isbn: String) -> BookDTO?
    
    // delete
    func deleteBook(_ id: ObjectId)
    
    // exist
    func isExistBook(title: String, isbn: String) -> Bool
    
}

final class DefaultBookRepository: BookRepository {
    var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func createBook(_ book: BookDTO) {
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
    
    func fetch(keyword: String) -> Results<BookDTO> {
        let list = realm.objects(BookDTO.self).where {
            $0.title.contains(keyword, options: .caseInsensitive)
            || $0.content.contains(keyword, options: .caseInsensitive)
        }
        return list
    }
    
    func fetch(title: String, isbn: String) -> BookDTO? {
        let bookList = fetchAll()

        let bookInfo = bookList.where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.first
        
        return bookInfo
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
    
    func validateBook(_ id: ObjectId) -> Bool {
        guard let book = realm.object(ofType: BookDTO.self, forPrimaryKey: id) else { return false }
        let reviewCount = book.reviewList.count
        return reviewCount > 0 ? true : false
    }
}
