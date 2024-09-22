//
//  BookReviewViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/21/24.
//

import SwiftUI
import Combine
import RealmSwift

final class BookReviewViewModel: BaseViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var bookCoverImage = UIImage()
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    @ObservedRealmObject var bookInfo: BookInfo
    private let fileManager = ImageFileManager.shared
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        transform()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.output.bookCoverImage = self.fileManager.loadImageToDocument(filename: "\(self.bookInfo.id)") ?? UIImage()
            }
            .store(in: &cancellables)
        
    }
}
