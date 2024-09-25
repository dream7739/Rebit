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
    init() {
        
        let config = Realm.Configuration(
            schemaVersion: 1, // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: BookReview.className()) { oldObject, newObject in
                        guard let new = newObject else {return}
                        guard let old = oldObject else {return}
                        
                        if old["status"] as! String == "독서예정" {
                            new["status"] = 0
                        } else if old["status"] as! String == "독서중" {
                            new["status"] = 1
                        } else {
                            new["status"] = 2
                        }
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
