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
        let updateOccured = PassthroughSubject<BookReview, Never>()
        let deleteButtonClicked = PassthroughSubject<BookReview, Never>()
        let isLikeClicked = PassthroughSubject<BookReview, Never>()
    }
    
    struct Output {
        var bookInfo = BookInfo()
        var bookCoverImage = UIImage()
        let isReviewChanged = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    var bookInfo: BookInfo

    private let fileManager = ImageFileManager.shared
    private let repository = RealmRepository()
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        transform()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.output.bookCoverImage = self.fileManager.loadImageToDocument(filename: "\(self.bookInfo.id)") ?? UIImage()
                self.output.bookInfo = repository.fetchBook(bookInfo.id)
            }
            .store(in: &cancellables)
       
        input.updateOccured
            .sink { [weak self] review in
                guard let self = self else { return }
                guard let book = review.book.first else { return }
                self.output.bookInfo = repository.fetchBook(book.id)
            }
            .store(in: &cancellables)
        
        input.deleteButtonClicked
            .sink { [weak self] review in
                guard let self = self else { return }
                let reviewId = review.id
                let bookId = self.output.bookInfo.id
                
                // 리뷰 삭제
                self.repository.deleteReview(reviewId)
                
                // 리뷰가 없을 경우 책 삭제
                if !self.repository.validateBook(bookId) {
                    //이미지 파일 삭제
                    fileManager.removeImageFromDocument(filename: "\(bookId)")
                    self.repository.deleteBook(bookId)
                }
                
                //새롭게 책 정보를 패치
                output.bookInfo = self.repository.fetchBook(bookId)
                self.bookInfo = BookInfo()
                output.isReviewChanged.send(())
            }
            .store(in: &cancellables)
        
        input.isLikeClicked
            .sink { [weak self] review in
                guard let self = self else { return }
                let reviewId = review.id
                let bookId = self.output.bookInfo.id

                self.repository.updateLike(reviewId)
                output.bookInfo = self.repository.fetchBook(bookId)
            }
            .store(in: &cancellables)
    }
}
