//
//  EntireShelfViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/22/24.
//

import Foundation
import Combine
import RealmSwift

final class EntireShelfViewModel: BaseViewModel {
    struct Input {
        var text = CurrentValueSubject<String, Never> ("")
    }
    
    struct Output {
        var bookList = Array<BookInfo>()
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    @ObservedResults(BookInfo.self)
    var bookList
    
    private let fileManager = ImageFileManager.shared
    
    init() {
        transform()
    }
    
    func transform() {
        input.text
            .sink { [weak self] value in
                guard let self = self else { return }
                
                if value.isEmpty {
                    output.bookList = bookList.map { $0 }
                } else {
                    output.bookList = bookList
                        .where { $0.title.contains(value, options: .caseInsensitive) }
                        .map { $0 }
                }
            }
            .store(in: &cancellables)
    }
}
