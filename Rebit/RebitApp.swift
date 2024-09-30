//
//  RebitApp.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

@main
struct RebitApp: App {
//    init() {
//        let config = Realm.Configuration(
//            schemaVersion: 1, // 새로운 스키마 버전 설정
//            migrationBlock: { migration, oldSchemaVersion in
//                if oldSchemaVersion < 1 {
//                    migration.enumerateObjects(ofType: BookReview.className()) { oldObject, newObject in
//                        guard let new = newObject else {return}
//                        guard let old = oldObject else {return}
//                        
//                        guard let date = old["endDate"] as? Date else { return }
//                        new["year"] = Calendar.current.component(.year, from: date)
//                    }
//                }
//            }
//        )
//        
//        Realm.Configuration.defaultConfiguration = config
//    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
