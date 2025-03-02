//
//  BookWriteModel.swift
//  Rebit
//
//  Created by 홍정민 on 2/26/25.
//

import Foundation
import Combine

protocol BookWriteModelStateProtocol: AnyObject {
    var book: BookContentDTO? { get }
    var review: BookReview? { get }
    var viewType: BookWriteViewType { get }
    var summaryText: String { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
    var reviewText: String { get set }
    var selectedStatus: Int { get set }
    var rating: Double { get set }
    var dismissRequest: PassthroughSubject<Void, Never> { get set }
}

protocol BookWriteModelActionProtocol: AnyObject {
    func displayExistReview()
    func dismissRequestTrigger()
}

final class BookWriteModel: ObservableObject, BookWriteModelStateProtocol {
    // 생성 시 넘겨받아 사용할 값
    var book: BookContentDTO?
    var review: BookReview?
    var viewType: BookWriteViewType
    
    // 사용자 입력값
    @Published var summaryText: String = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var reviewText = ""
    @Published var selectedStatus = 0
    @Published var rating = 0.0
    var dismissRequest = PassthroughSubject<Void, Never>()
    
    init(
        viewType: BookWriteViewType,
        book: BookContentDTO? = nil,
        review: BookReview? = nil
    ) {
        self.viewType = viewType
        self.book = book
        self.review = review
    }
    
    func displayExistReview() {
        guard let review = review else { return }
        summaryText = review.title
        startDate = review.startDate ?? Date()
        endDate = review.endDate ?? Date()
        reviewText = review.content
        selectedStatus = review.status
    }
    
    func dismissRequestTrigger() {
        dismissRequest.send(())
    }
}
