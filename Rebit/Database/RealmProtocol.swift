//
//  RealmProtocol.swift
//  Rebit
//
//  Created by 홍정민 on 10/15/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol: AnyObject {
    associatedtype RealmDataSource: RealmCollectionValue
    var realm: Realm { get set }
    func add(object: RealmDataSource)
    func fetchAll() -> Results<RealmDataSource>
    
}
