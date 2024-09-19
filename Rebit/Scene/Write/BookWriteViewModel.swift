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
    var book: Book?

    struct Input {
        var saveReview = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var summaryText = ""
        var startDate = Date()
        var endDate = Date()
        var rating = 5.0
        var reviewText = ""
        var selectedStatus = 0
        var dismissRequest = PassthroughSubject<Void, Never>()
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    private let repository = RealmRepository()
    private let fileManager = ImageFileManager.shared
    
    init() {
        transform()
    }
    
    func transform() {
        //1) 책 정보가 존재 > 리뷰만 저장
        //2) 책 정보가 존재하지 않음 > 책 저장 > 리뷰 저장
        
        let saveBook = PassthroughSubject<Void, Never>()
        let saveReview = PassthroughSubject<Void, Never>()
        
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
                    rating: self?.output.rating ?? 0,
                    status: ReadingStatus(rawValue: self?.output.selectedStatus ?? 0)!.title,
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
                return "독서예정"
            case .current:
                return "독서중"
            case .completed:
                return "독서완료"
            }
        }
    }
}
