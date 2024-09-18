//
//  RealmRepository.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func addBookInfo(_ item: BookInfo) {
        do{
            try realm.write {
                realm.add(item)
            }
        }catch{
            print("Add Realm Item Failed")
        }
    }
    
    func addBookReview( _ book: BookInfo, _ item: BookReview) {
        do {
            try realm.write {
                book.reviewList.append(item)
            }
        } catch {
            print("Add Realm Item Failed")
        }
    }
    
    func fetchAllBooks() -> Results<BookInfo> {
        let list = realm.objects(BookInfo.self)
        return list
    }
    
}


extension RealmRepository {
    func isBookExist(title: String, isbn: String) -> Bool {
        let bookList = fetchAllBooks()
        
        let existCount = bookList.where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.count
        
        return existCount >= 1
    }
    
    func getBookObject(title: String, isbn: String) -> BookInfo? {
        let bookList = fetchAllBooks()

        let bookInfo = bookList.where {
            $0.title.equals(title) && $0.isbn.equals(isbn)
        }.first
        
        return bookInfo
    }
}
