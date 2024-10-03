//
//  BookWriteViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation
import Combine
import RealmSwift

typealias ReadingStatus = BookWriteViewModel.ReadingStatus

final class BookWriteViewModel: BaseViewModel {
    
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
        let saveReview = PassthroughSubject<Void, Never>()
        let modifyReview = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var summaryText = ""
        var startDate = Date()
        var endDate = Date()
        var reviewText = ""
        var selectedStatus = 0
        var dismissRequest = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    var book: Book?
    var bookReview: BookReview?
    var rating: Double = 0.0
    
    private let repository = RealmRepository()
    private let fileManager = ImageFileManager.shared
    
    init(book: Book? = nil, bookReview: BookReview? = nil) {
        self.book = book
        self.bookReview = bookReview
        transform()
    }
    
    /* 신규 저장
     * 1) 책 정보가 존재 > 리뷰만 저장
     * 2) 책 정보가 존재하지 않음 > 책 저장 > 리뷰 저장
     *
     * 리뷰 수정
     * 1) Realm 오브젝트에 접근해서 수정
     */
    func transform() {
        let saveBook = PassthroughSubject<Void, Never>()
        let saveReview = PassthroughSubject<Void, Never>()
        
        //첫 진입 시
        input.viewOnAppear
            .compactMap { [weak self] in
                self?.bookReview
            }
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.summaryText = value.title
                self.output.startDate = value.startDate ?? Date()
                self.output.endDate = value.endDate ?? Date()
                self.output.reviewText = value.content
                self.output.selectedStatus = value.status
            }
            .store(in: &cancellables)
        
        //리뷰 신규 저장
        input.saveReview
            .compactMap { [weak self] in
                self?.book
            }
            .sink { [weak self] value in
                if self?.repository.isBookExist(title: value.title, isbn: value.isbn) ?? false {
                    saveReview.send(())
                } else {
                    saveBook.send(())
                    saveReview.send(())
                }
            }
            .store(in: &cancellables)
        
        saveBook
            .compactMap { [weak self] in
                self?.book
            }
            .map {
                BookInfo(
                    title: $0.title,
                    content: $0.description,
                    author: $0.author,
                    isbn: $0.isbn,
                    pubdate: $0.dateDescription,
                    publisher: $0.publisher
                )
            }
            .sink { [weak self] value in
                self?.repository.addBookInfo(value)
            }
            .store(in: &cancellables)
        
        saveReview
            .compactMap { [weak self] in
                self?.book
            }
            .compactMap { [weak self] in
                self?.repository.getBookObject(title: $0.title, isbn: $0.isbn)
            }
            .map { [weak self] bookInfo in
                let review = BookReview(
                    title: self?.output.summaryText ?? "",
                    content: self?.output.reviewText ?? "" ,
                    rating: self?.rating ?? 0,
                    status: self?.output.selectedStatus ?? 0,
                    year: Calendar.current.component(.year, from: self?.output.endDate ?? Date()),
                    startDate: self?.output.startDate,
                    endDate: self?.output.endDate
                )
                return (bookInfo: bookInfo, review: review)
            }
            .sink { [weak self] (bookInfo, review) in
                self?.repository.addBookReview(bookInfo, review)
                guard let image = self?.book?.image else { return }
                self?.fileManager.saveImageToDocument(path: image, filename: "\(bookInfo.id)")
                self?.output.dismissRequest.send(())
            }
            .store(in: &cancellables)
        
        //리뷰 수정
        input.modifyReview
            .compactMap { [weak self] in
                self?.bookReview
            }
            .map { oldReview in
                let newReview = BookReview(
                    title: self.output.summaryText.trimmingCharacters(in: .whitespacesAndNewlines),
                    content: self.output.reviewText.trimmingCharacters(in: .whitespacesAndNewlines),
                    rating: self.rating,
                    status: self.output.selectedStatus,
                    year: Calendar.current.component(.year, from: self.output.endDate),
                    startDate: self.output.startDate,
                    endDate: self.output.endDate
                )
                return (oldReview, newReview)
            }
            .sink { [weak self] (oldReview: BookReview, newReview: BookReview) in
                guard let self = self else { return }
                repository.updateBookReview(oldReview, newReview)
                self.output.dismissRequest.send(())
            }
            .store(in: &cancellables)
    }
    
}

extension BookWriteViewModel {
    enum ReadingStatus: Int, CaseIterable {
        case expected = 0
        case current
        case completed
        
        var title: String {
            switch self {
            case .expected:
                return "reading-expected".localized
            case .current:
                return "reading-current".localized
            case .completed:
                return "reading-completed".localized
            }
        }
        
        var endDateTitle: String {
            switch self {
            case .expected:
                return ""
            case .current:
                return "목표종료일"
            case .completed:
                return "종료일"
            }
        }
        
        var summaryTitle: String {
            switch self {
            case .expected:
                return "이 책에 대한 기대평을 입력해보세요"
            case .current, .completed:
                return "나만의 한줄평을 입력해보세요"
            }
        }
    }
}
