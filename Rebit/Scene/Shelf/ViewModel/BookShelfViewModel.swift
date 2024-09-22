//
//  BookShelfViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

final class BookShelfViewModel: BaseViewModel {
    struct Input {
    }
    
    struct Output {
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    @ObservedResults(
        BookInfo.self,
        sortDescriptor: SortDescriptor(keyPath: "saveDate", ascending: false)
    )
    var bookList
    
    @ObservedResults(
        BookInfo.self,
        where: ({ $0.reviewList.status == "독서중" }),
        sortDescriptor: SortDescriptor(keyPath: "saveDate", ascending: false)
    )
    var currentBookList
    
    private let fileManager = ImageFileManager.shared
    
    init() {
        transform()
    }
    
    func transform() {
      
    }
}
