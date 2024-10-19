//
//  BookSearchViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import Foundation
import Combine


final class BookSearchViewModel: BaseViewModel {
    @Published var searchText = ""
    
    var bookRequest = BookRequest(query: "")
    var bookResponse = BookResponse(total: 0, start: 0, display: 0, items: [])
    
    struct Input {
        var callSearch = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var isInitial = true
        var scrollToTop = PassthroughSubject<Void, Never>()
        var bookList: [Book] = []
    }
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
    
    //일반 함수 -> async 함수 호출 불가
    //Task 인스턴스를 통해 비동기 작업 수행 가능
    //async 함수 호출 시 일반적으로 await 키워드를 삽입
    func transform() {
        input.callSearch
            .map { [weak self] in
                guard let self = self else { return }
                let text = self.searchText.trimmingCharacters(in: .whitespaces).lowercased()
                if text.isEmpty || text == bookRequest.query { return }
                bookRequest.start = 1
                bookRequest.query = text
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.callRequest()
                }
            }
            .store(in: &cancellables)
        
    }
}

extension BookSearchViewModel {
    @MainActor
    func callRequest() {
        Task {
            do {
                let result = try await APIManager.shared.callRequest(request: self.bookRequest)
                self.output.isInitial = false
                self.bookResponse = result
                self.output.bookList = result.items
                self.output.scrollToTop.send(())
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func callRequestMore() {
        bookRequest.start += 1
        Task {
            do {
                let result = try await APIManager.shared.callRequest(request: bookRequest)
                bookResponse = result
                output.bookList.append(contentsOf: result.items)
            } catch {
                print(error)
            }
        }
    }
    
    var isPaginationRequired: Bool {
        let pageCnt = 30
        let afterPageCnt = output.bookList.count + pageCnt
        return bookResponse.total >= afterPageCnt ? true : false
    }
}
