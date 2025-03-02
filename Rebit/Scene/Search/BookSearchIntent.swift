//
//  SearchIntent.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Combine

protocol BookSearchIntentProtocol: AnyObject {
    func viewOnAppear()
    func searchBook(query: String)
    func searchPagination()
}

final class BookSearchIntent: BookSearchIntentProtocol {
    private var model: BookSearchModel
    private var networkManager: NetworkType
    private var bookRequest = BookRequestDTO(query: "")
    private var bookResponse = BookResponseDTO(
        total: 0,
        start: 0,
        display: 0,
        items: []
    )

    init(
        model: BookSearchModel,
        networkManager: NetworkType
    ) {
        self.model = model
        self.networkManager = networkManager
    }
    
    func viewOnAppear() {
        if bookResponse.items.isEmpty {
            model.displayInitial()
        }
    }
    
    func searchBook(query: String) {
        let text = query.trimmingCharacters(in: .whitespaces).lowercased()
        bookRequest.query = text
        
        Task {
            do {
                bookResponse = try await networkManager.callRequest(request: bookRequest)
                let books = bookResponse.items

                await MainActor.run {
                    if books.isEmpty {
                        model.displayNoResult()
                        return
                    } else {
                        model.updateContent(books: books)
                        model.scrollToTop.send(())
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func searchPagination() {
        if isPaginationRequired {
            bookRequest.start += 1
            Task {
                do {
                    let response = try await networkManager.callRequest(request: bookRequest)
                    bookResponse.items.append(contentsOf: response.items)
                    
                    await MainActor.run {
                        model.updateContent(books: bookResponse.items)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private var isPaginationRequired: Bool {
        let pageCount = 30
        let afterCount = bookResponse.items.count + pageCount
        return bookResponse.total >= afterCount ? true : false
    }
}
