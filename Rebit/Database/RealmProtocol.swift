//
//  RealmProtocol.swift
//  Rebit
//
//  Created by 홍정민 on 10/15/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol: AnyObject {
    //어떤 데이터소스를 사용할 지 알 수 없기 때문에 제네릭으로 정의
    //RealmCollectionValue를 채택한 타입만 들어올 수 있음
    associatedtype RealmDataSource: RealmCollectionValue
    var realm: Realm { get set }
    func add(object: RealmDataSource)
    func fetchAll() -> Results<RealmDataSource>
    
}
