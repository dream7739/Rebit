//
//  BookSearchView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject var container: MVIContainer<SearchIntent, SearchModel>
    private var state: SearchModel { container.model }
    private var intent: SearchIntent { container.intent }
    
    var body: some View {
        VStack {
            SearchBarView(text: container.binding(for: \.searchText))
                .padding(10)
                .onSubmit {
                    intent.searchButtonClicked(query: state.searchText)
                }
            searchContentView()
        }
        .onAppear {
            intent.viewOnAppear()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

}

extension BookSearchView {
    @ViewBuilder
    func searchContentView() -> some View {
        switch state.contentState {
        case .initial:
            PlaceholderView(text: state.placeholder, type: .search)
        case .content(let books):
            searchListView(bookList: books)
        case .noResult:
            PlaceholderView(text: state.noResults, type: .shelf)
        }
    }
    
    func searchListView(bookList: [Book]) -> some View {
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(Array(zip(bookList.indices, bookList)), id: \.0) { index, item in
                        SearchRowView(book: item)
                            .onAppear {
                                if index == bookList.count - 4 {
                                    intent.paginationRequired()
                                }
                            }
                    }
                }
            }
            .onReceive(state.scrollToTop) { _ in
                reader.scrollTo(0, anchor: .top)
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

extension BookSearchView {
    static func build() -> some View {
        let model = SearchModel()
        let intent = SearchIntent(
            model: model,
            networkManager: APIManager.shared
        )
        let container = MVIContainer(
            intent: intent,
            model: model,
            modelChangePublisher: model.objectWillChange
        )
        let view = BookSearchView(container: container)
        return view
    }
}
