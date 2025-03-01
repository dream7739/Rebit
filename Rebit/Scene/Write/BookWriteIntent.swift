//
//  BookWriteIntent.swift
//  Rebit
//
//  Created by 홍정민 on 2/26/25.
//

import Foundation

// 책 리뷰 저장 Intent
// 1. viewOnAppear: 초기 진입 시
// 2. saveReviewClicked: 신규 리뷰 작성
protocol BookWriteIntentProtocol: AnyObject {
    func viewOnAppear()
    func saveReviewClicked()
}

final class BookWriteIntent: BookWriteIntentProtocol {
    let model: BookWriteModel
    let bookRepository: BookRepository
    let reviewRepository: ReviewRepository
    let fileManager = ImageFileManager.shared
    
    init(
        model: BookWriteModel,
        bookRepository: BookRepository,
        reviewRepository: ReviewRepository
    ) {
        self.model = model
        self.bookRepository = bookRepository
        self.reviewRepository = reviewRepository
    }
    
    // 화면 첫 진입 시
    func viewOnAppear() {
        if model.viewType == .edit {
            model.displayExistReview()
        }
    }
    
    // 리뷰 저장버튼 클릭 시
    // 리뷰 신규 저장: saveReview
    // 기존 리뷰 갱신: updateReview
    func saveReviewClicked() {
        switch model.viewType {
        case .add:
            saveReview()
        case .edit:
            updateReview()
        }
    }
}

extension BookWriteIntent {
    // 신규 리뷰 저장
    // 1. 책이 저장되어 있지 않은 경우: 리뷰만 저장
    // 2. 책이 저장되어 있는 경우: 책과 책 커버 이미지, 리뷰를 함께 저장
    
    // 리뷰 저장 완료 후
    // 모델에 dismiss 트리거 전달
    func saveReview() {
        guard let book = model.book else { return }
        
        if bookRepository.isExistBook(
            title: book.title,
            isbn: book.isbn
        ) {
            saveReviewData(book)
        } else {
            saveBookData(book)
            saveReviewData(book)
        }
        
        model.dismissRequestTrigger()
    }
    
    // 기존 리뷰 갱신
    // 기존 리뷰를 사용자가 작성한 값으로 데이터베이스 갱신
    
    // 리뷰 갱신 완료 후
    // 모델에 dismiss 트리거 전달
    func updateReview() {
        guard let oldReview = model.review else { return }
        let newReview = createNewReviewData()
        reviewRepository.updateReview(oldReview, newReview)
        model.dismissRequestTrigger()
    }
    
    // 데이터베이스 책 저장
    // 책 커버 이미지 저장
    func saveBookData(_ book: Book) {
        let bookInfo = BookInfo(
            title: book.title,
            content: book.description,
            author: book.author,
            isbn: book.isbn,
            pubdate: book.dateDescription,
            publisher: book.publisher
        )
        
        bookRepository.addBook(bookInfo)
        fileManager.saveImageToDocument(path: book.image, filename: "\(bookInfo.id)")
    }
    
    
    // 데이터베이스 리뷰 저장
    // 1. 가지고 있는 책 정보를 통해 데이터베이스에 저장된 책을 가져온다.
    // 2. 데이터베이스에 리뷰를 저장한다.
    func saveReviewData(_ book: Book) {
        guard let bookInfo = bookRepository.getBookObject(
            title: book.title,
            isbn: book.isbn
        ) else { return }
        
        let bookReview = BookReview(
            title: model.summaryText,
            content: model.reviewText,
            rating: model.rating,
            status: model.selectedStatus,
            year: Calendar.current.component(.year, from: model.endDate),
            startDate: model.startDate,
            endDate: model.endDate
        )
        
        reviewRepository.createReview(bookInfo, bookReview)
    }
    
    // 사용자 작성값으로 리뷰를 구성
    func createNewReviewData() -> BookReview {
        let newReview = BookReview(
            title: model.summaryText.trimmingCharacters(in: .whitespacesAndNewlines),
            content: model.reviewText.trimmingCharacters(in: .whitespacesAndNewlines),
            rating: model.rating,
            status: model.selectedStatus,
            year: Calendar.current.component(.year, from: model.endDate),
            startDate: model.startDate,
            endDate: model.endDate
        )
        return newReview
    }
}

