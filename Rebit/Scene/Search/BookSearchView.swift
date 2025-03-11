//
//  BookSearchView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject var container: MVIContainer<BookSearchIntentProtocol, BookSearchModelStateProtocol>
    private var state: BookSearchModelStateProtocol { container.model }
    private var intent: BookSearchIntentProtocol { container.intent }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(text: container.binding(for: \.searchText))
                    .padding(10)
                    .onSubmit {
                        intent.searchBook(query: state.searchText)
                    }
                searchContentView()
            }
            .asMainToolbar()
        }
        .onAppear {
            intent.viewOnAppear()
        }
    }
    
    @ViewBuilder
    func searchContentView() -> some View {
        switch state.contentState {
        case .initial:
            PlaceholderView(text: state.placeholder)
        case .content(let books):
            searchListView(bookList: books)
        case .noResult:
            PlaceholderView(text: state.noResults)
        }
    }
    
    func searchListView(bookList: [BookContentDTO]) -> some View {
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(Array(zip(bookList.indices, bookList)), id: \.0) { index, item in
                        SearchRowView(book: item)
                            .onAppear {
                                if index == bookList.count - 4 {
                                    intent.searchPagination()
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

struct SearchRowView: View {
    var book: BookContentDTO
    @Environment(\.colorScheme) var color
    
    var body: some View {
        NavigationLinkWrapper {
            BookDetailView(book: book)
        } inner: {
            HStack(alignment: .top, spacing: 15) {
                CoverImageView(url: book.image)
                    .frame(width: 90, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(book.title)
                        .font(.callout.bold())
                        .lineLimit(2)
                    Text(book.author)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundStyle(.gray)
                    Text(book.description)
                        .font(.caption)
                        .lineLimit(3)
                        .foregroundStyle(.gray)
                        .padding(.vertical, 3)
                    HStack {
                        Spacer()
                        WriteButtonView()
                    }
                    .padding(.top, 2)
                }
            }
            .padding()
            .background(
                Rectangle()
                    .fill(color == .light ? .white : .black)
            )
        }
    }
}


extension BookSearchView {
    static func build() -> some View {
        let model = BookSearchModel()
        let intent = BookSearchIntent(
            model: model,
            networkManager: APIManager.shared
        )
        let container = MVIContainer(
            intent: intent as BookSearchIntentProtocol,
            model: model as BookSearchModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = BookSearchView(container: container)
        return view
    }
}
