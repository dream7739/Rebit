//
//  ReviewRepository.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import RealmSwift

final class ReviewRepository: RealmProtocol {
    typealias RealmDataSource = BookReview
    
    var realm = try! Realm()
    
    func add(object: BookReview) {
        print(#function)
    }
    
    func fetchAll() -> Results<BookReview> {
        let list = realm.objects(BookReview.self)
        return list
    }
    
    func fetchFavoriteList() -> [BookReview] {
        let list = realm.objects(BookReview.self)
            .filter { $0.isLike }
            .sorted { $0.saveDate > $1.saveDate }
            .map { $0 }
        return list
    }
}
