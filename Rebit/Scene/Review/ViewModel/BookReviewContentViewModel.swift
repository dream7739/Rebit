//
//  BookReviewContentViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/22/24.
//

import Foundation
import Combine
import RealmSwift

final class BookReviewContentViewModel: BaseViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
        let modifyOccured = PassthroughSubject<Void, Never>()
        let isLikeClicked = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var bookInfo = BookInfo()
        var reviewInfo = BookReview()
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    @ObservedRealmObject var reviewInfo: BookReview

    private let fileManager = ImageFileManager.shared
    private let repository = RealmRepository()
    
    init(reviewInfo: BookReview) {
        self.reviewInfo = reviewInfo
        transform()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                //책 관련 정보
                if let book = self.reviewInfo.book.first {
                    self.output.bookInfo = book
                }
                
                //리뷰 관련 정보
                self.output.reviewInfo = reviewInfo
                
            }
            .store(in: &cancellables)
        
        input.modifyOccured
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.reviewInfo = repository.fetchReview(self.reviewInfo.id)
                self.output.reviewInfo = self.reviewInfo
            }
            .store(in: &cancellables)
        
        input.isLikeClicked
            .sink { [weak self] in
                guard let self = self else { return }
                //ObservedRealmObject <- Frozen Object
                //변경시 realm트랜잭션 안에서 thaw 사용
                $reviewInfo.isLike.wrappedValue.toggle()
                output.reviewInfo = repository.fetchReview(self.reviewInfo.id)
            }
            .store(in: &cancellables)
        
        
    }
}
