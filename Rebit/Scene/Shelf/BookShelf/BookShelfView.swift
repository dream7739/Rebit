//
//  BookShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    @StateObject private var container: MVIContainer<BookShelfIntentProtocol, BookShelfModelStateProtocol>
    private var state: BookShelfModelStateProtocol { container.model }
    private var intent: BookShelfIntentProtocol { container.intent }
    @State private var isActive: Bool = false

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(alignment: .leading, spacing: 10) {
                    nowReadingSection(proxy.size.height * 0.3)
                    mybookShelfSection(proxy.size.height * 0.6)
                    Spacer()
                }
                .padding()
                .asMainToolbar()
            }
        }
        .onAppear {
            intent.viewOnAppear()
        }
        .onChange(of: isActive) { newValue in
            intent.viewOnAppear()
        }
    }
    
    func nowReadingSection(_ height: CGFloat) -> some View {
        VStack(alignment: .leading) {
            Text("shelf-announce".localized)
                .font(.callout)
                .bold()
            
            asHorizontalPageContent(height: height * 0.9) {
                switch state.contentState.expectedStatus {
                case .normal:
                    ForEach(state.expectedReviewList, id: \.id) { item in
                        NavigationLinkWrapper {
                            BookReviewView.build(book: item.book, isActive: $isActive)
                        } inner: {
                            ExpectedReadingView(bookReviewContent: item)
                        }
                    }
                    
                case .empty:
                    Text("shelf-announce-empty".localized)
                        .foregroundStyle(.gray)
                        .font(.callout)
                        .frame(maxHeight: height * 0.9, alignment: .center)
                }
            }
        }
        .frame(height: height)
    }
    
    func mybookShelfSection(_ height: CGFloat) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("shelf-my".localized)
                    .bold()
                    .font(.callout)
                Spacer()
                NavigationLinkWrapper {
                    EntireShelfView.build()
                } inner: {
                    Text("shelf-detail".localized)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            shelfGridView()
        }
        .frame(minHeight: height)
    }
    
    func shelfGridView() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return GeometryReader { proxy in
            let height = (proxy.size.height / 2) - 20
            let width = height / 1.5
            let size = CGSize(width: width, height: height)
            
            switch state.contentState.bookStatus {
            case .normal:
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(state.bookList, id: \.id) { item in
                        NavigationLinkWrapper {
                            BookReviewView.build(book: item, isActive: $isActive)
                        } inner: {
                            ShelfBookView(bookList: item, size: size)
                        }
                    }
                })
            case .excess:
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(0..<6) { item in
                        NavigationLinkWrapper {
                            BookReviewView.build(book: state.bookList[item], isActive: $isActive)
                        } inner: {
                            ShelfBookView(bookList: state.bookList[item], size: size)
                        }
                    }
                })
            case .empty:
                PlaceholderView(text: state.placeholderText, type: .shelf)
            }
        }
    }
}

extension BookShelfView {
    static func build() -> some View {
        let model = BookShelfModel()
        let intent = BookShelfIntent(
            model: model,
            bookRepository: DefaultBookRepository(),
            reviewRepository: DefaultReviewRepository()
        )
        let container = MVIContainer(
            intent: intent as BookShelfIntentProtocol,
            model: model as BookShelfModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = BookShelfView(
            container: container
        )
        return view
    }
}
