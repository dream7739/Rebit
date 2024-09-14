//
//  BookSearchViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import Foundation
import Combine


final class BookSearchViewModel: BaseViewModel, ObservableObject {
    @Published var searchText = ""
    
    var bookRequest = BookRequest(query: "")
    var bookResponse = BookResponse(total: 0, start: 0, display: 0, items: [])
    
    struct Input {
        var callSearch = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var bookList: [Book] = []
    }
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
    
    func transform() {
        input.callSearch
            .sink { [weak self] _ in
                self?.callRequest()
            }
            .store(in: &cancellables)
        
        let publisher = Just("jm")
        
        publisher
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print(result)
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { value in
                print(value)
            })
            .store(in: &cancellables)
        
        
    }
 
    
}

extension BookSearchViewModel {
    func callRequest() {
        
        let text = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if text.isEmpty || text == bookRequest.query { return }
        
        bookRequest.start = 1
        bookRequest.query = text
        
        APIManager.fetchBooks(request: bookRequest)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] data in
                self?.bookResponse = data
                self?.output.bookList = data.items
            }
            .store(in: &cancellables)
    }
    
    func callRequestMore() {
        
        bookRequest.start += 1
        
        APIManager.fetchBooks(request: bookRequest)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] data in
                self?.bookResponse = data
                self?.output.bookList.append(contentsOf: data.items)
            }
            .store(in: &cancellables)
    }
    
    var isPaginationRequired: Bool {
        let pageCnt = 30
        let afterPageCnt = output.bookList.count + pageCnt
        return bookResponse.total >= afterPageCnt ? true : false
    }
}
