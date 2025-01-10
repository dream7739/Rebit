//
//  ReadingGoal.swift
//  Rebit
//
//  Created by 홍정민 on 1/10/25.
//

import Foundation
import RealmSwift

final class ReadingGoal: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var year: Int
    @Persisted var month: Int
    @Persisted var goal: Int
    @Persisted var saveDate: Date
    
    convenience init(
        year: Int,
        month: Int,
        goal: Int
    ) {
        self.init()
        self.year = year
        self.month = month
        self.goal = goal
        self.saveDate = Date()
        
    }
}
