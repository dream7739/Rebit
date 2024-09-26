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
    
    func addBookInfo(_ book: BookInfo) {
        do{
            try realm.write {
                realm.add(book)
            }
        }catch{
            print("Add Realm Item Failed")
        }
    }
    
    func addBookReview( _ book: BookInfo, _ review: BookReview) {
        do {
            try realm.write {
                book.reviewList.append(review)
            }
        } catch {
            print("Add Realm Item Failed")
        }
    }
    
    func fetchAllBooks() -> Results<BookInfo> {
        let list = realm.objects(BookInfo.self)
        return list
    }
    
    func fetchAllReview() -> Results<BookReview> {
        let list = realm.objects(BookReview.self)
        return list
    }
    
    func fetchReview(_ id: ObjectId) -> BookReview {
        let review = realm.object(ofType: BookReview.self, forPrimaryKey: id) ?? BookReview()
        return review
    }
    
    func modifyBookReview(_ oldReview: BookReview, _ newReview: BookModifyModel) {
        do {
            try realm.write {
                oldReview.thaw()?.title = newReview.title
                oldReview.thaw()?.startDate = newReview.startDate
                oldReview.thaw()?.endDate = newReview.endDate
                oldReview.thaw()?.rating = newReview.rating
                oldReview.thaw()?.content = newReview.content
                oldReview.thaw()?.status = newReview.status
            }
        } catch {
            print("Modify Realm Item Failed")
        }
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
