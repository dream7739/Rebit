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
        let isLikeClicked = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        //책 정보
        var title = ""
        var author = ""
        var reviewCnt = ""
        //리뷰정보
        var reviewTitle = ""
        var reviewContent = ""
        var period = ""
        var rating = ""
        var saveDate = ""
        var isLike = false
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    @ObservedRealmObject var reviewInfo: BookReview
    private let fileManager = ImageFileManager.shared
    
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
                    self.output.title = book.title
                    self.output.author = book.author
                    self.output.reviewCnt = book.reviewCountDescription
                }
                
                //리뷰 관련 정보
                self.output.reviewTitle = reviewInfo.title
                self.output.reviewContent = reviewInfo.content
                self.output.period = reviewInfo.periodDescription
                self.output.rating = reviewInfo.ratingDescription
                self.output.saveDate = reviewInfo.saveDateDescription
                self.output.isLike = reviewInfo.isLike
                
            }
            .store(in: &cancellables)
        
        input.isLikeClicked
            .sink { [weak self] in
                guard let self = self else { return }
                $reviewInfo.isLike.wrappedValue.toggle()
                self.output.isLike = reviewInfo.isLike
            }
            .store(in: &cancellables)
    }
}
