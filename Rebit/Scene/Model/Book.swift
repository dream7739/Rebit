//
//  Book.swift
//  Rebit
//
//  Created by 홍정민 on 3/2/25.
//

import Foundation
import RealmSwift

struct Book: Hashable, Identifiable {
    let id: ObjectId
    let title: String
    let content: String
    let author: String
    let isbn: String
    let publisher: String
    var pubdate: String
    var saveDate: Date
}
