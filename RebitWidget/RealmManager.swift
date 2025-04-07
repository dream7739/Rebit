//
//  RealmManager.swift
//  RebitWidgetExtension
//
//  Created by 홍정민 on 4/7/25.
//

import Foundation
import RealmSwift

final class RealmManager {
    private init() { }
    static let shared = RealmManager()
    
    private var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.jm.rebit")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return try! Realm(configuration: config)
    }
    
    func getLatestFavoriteReview() -> BookReviewDTO? {
        let review = realm.objects(BookReviewDTO.self).where { $0.isLike }.first
        return review
    }
    
}
