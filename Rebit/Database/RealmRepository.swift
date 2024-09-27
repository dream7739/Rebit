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
    
    // 책
    func addBookInfo(_ book: BookInfo) {
        do{
            try realm.write {
                realm.add(book)
            }
        }catch{
            print("add book failed")
        }
    }
    
    func addBookReview( _ book: BookInfo, _ review: BookReview) {
        do {
            try realm.write {
                book.reviewList.append(review)
            }
        } catch {
            print("add book review failed")
        }
    }
    
    func fetchAllBooks() -> Results<BookInfo> {
        let list = realm.objects(BookInfo.self)
        return list
    }
    
    func fetchBook(_ id: ObjectId) -> BookInfo {
        let book = realm.object(ofType: BookInfo.self, forPrimaryKey: id) ?? BookInfo()
        return book
    }
    
    func deleteBook(_ id: ObjectId) {
        let book = fetchBook(id)
        
        do {
            try realm.write {
                realm.delete(book)
            }
        } catch {
            print("delete book Failed")
        }
    }
    
    //리뷰
    func fetchAllReview() -> Results<BookReview> {
        let list = realm.objects(BookReview.self)
        return list
    }
    
    func fetchReview(_ id: ObjectId) -> BookReview {
        let review = realm.object(ofType: BookReview.self, forPrimaryKey: id) ?? BookReview()
        return review
    }

    func updateBookReview(_ oldReview: BookReview, _ newReview: BookReview) {
        let review = fetchReview(oldReview.id)
        
        do {
            try realm.write {
                review.title = newReview.title
                review.startDate = newReview.startDate
                review.endDate = newReview.endDate
                review.rating = newReview.rating
                review.content = newReview.content
                review.status = newReview.status
            }
        } catch {
            print("update book failed")
        }
    }
    
    func updateLike(_ id: ObjectId) {
        let review = fetchReview(id)
        
        do {
            try realm.write {
                review.isLike.toggle()
            }
        } catch {
            print("update like failed")
        }
    }
    
    func deleteReview(_ id: ObjectId) {
        let review = fetchReview(id)
        
        do {
            try realm.write {
                realm.delete(review)
            }
        } catch {
            print("delete review failed")
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
    
    func validateBook(_ id: ObjectId) -> Bool {
        guard let book = realm.object(ofType: BookInfo.self, forPrimaryKey: id) else { return false }
        let reviewCount = book.reviewList.count
        return reviewCount > 0 ? true : false
    }
}
