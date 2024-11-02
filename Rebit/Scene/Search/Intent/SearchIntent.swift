//
//  SearchIntent.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation
import Combine

protocol SearchIntentProtocol: AnyObject {
    func viewOnAppear()
    func searchButtonClicked(query: String)
    func paginationRequired()
}

final class SearchIntent: SearchIntentProtocol {
    private var model: SearchModel
    private var networkManager: NetworkType
    
    init(
        model: SearchModel,
        networkManager: NetworkType
    ) {
        self.model = model
        self.networkManager = networkManager
    }
    
    func viewOnAppear() {
        if model.bookResponse.items.isEmpty {
            model.displayInitial()
        }
    }
    
    func searchButtonClicked(query: String) {
        let text = query.trimmingCharacters(in: .whitespaces).lowercased()
        model.bookRequest.query = text
        model.page = 1
        
        Task {
            do {
                let bookResponse = try await callRequest(request: model.bookRequest)
                let bookList = bookResponse.items

                await MainActor.run {
                    if bookList.isEmpty {
                        model.displayNoResult()
                        return
                    } else {
                        model.bookResponse = bookResponse
                        model.updateContent()
                        model.scrollToTop.send(())
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func paginationRequired() {
        if isPaginationRequired() {
            model.bookRequest.start += 1
            Task {
                do {
                    let bookResponse = try await callRequest(request: model.bookRequest)
                    model.bookResponse.items.append(contentsOf: bookResponse.items)
                    
                    await MainActor.run {
                        model.updateContent()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    

}

extension SearchIntent {
    func callRequest(request: BookRequest) async throws -> BookResponse {
        do {
            let result = try await networkManager.callRequest(request: request)
            return result
        } catch {
            throw error
        }
    }
    
    func isPaginationRequired() -> Bool {
        let pageCnt = 30
        let afterPageCnt = model.bookResponse.items.count + pageCnt
        return model.bookResponse.total >= afterPageCnt ? true : false
    }
}
