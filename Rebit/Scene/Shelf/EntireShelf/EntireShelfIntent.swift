//
//  EntireShelfIntent.swift
//  Rebit
//
//  Created by 홍정민 on 3/5/25.
//

import Foundation

protocol EntireShelfIntentProtocol: AnyObject {
    func viewOnAppear()
    func searchTextOnChanged(searchText: String)
}

final class EntireShelfIntent: EntireShelfIntentProtocol {
    private let model: EntireShelfModel
    private let bookRepository: BookRepository
    
    init(model: EntireShelfModel, bookRepository: BookRepository) {
        self.model = model
        self.bookRepository = bookRepository
    }
    
    func viewOnAppear() {
        let bookList: [Book] = fetchBookList()
        model.displayInitial(bookList: bookList)
    }
    
    func searchTextOnChanged(searchText: String) {
        let keyword = searchText.trimmingCharacters(in: .whitespaces)
        
        if keyword.isEmpty {
            let bookList: [Book] = fetchBookList()
            model.displaySearchResult(bookList: bookList)
        } else {
            let bookList: [Book] = fetchBookList(keyword: keyword)
            
            if bookList.isEmpty {
                model.displayEmpty()
            } else {
                model.displaySearchResult(bookList: bookList)
            }
        }
    }
    
    func fetchBookList() -> [Book] {
        let bookListDTO = bookRepository.fetchAll()
        let bookList: [Book] = bookListDTO.map { $0.toBook() }
        return bookList
    }
    
    func fetchBookList(keyword: String) -> [Book] {
        let bookListDTO = bookRepository.fetch(keyword: keyword)
        let bookList: [Book] = bookListDTO.map { $0.toBook() }
        return bookList
    }
}
