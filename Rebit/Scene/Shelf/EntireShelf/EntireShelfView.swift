//
//  EntireShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct EntireShelfView: View {
    @StateObject private var container: MVIContainer<EntireShelfIntentProtocol, EntireShelfModelStateProtocol>
    private var intent: EntireShelfIntentProtocol { container.intent }
    private var state: EntireShelfModelStateProtocol { container.model }
    
    @State private var isActive = false
    
    var body: some View {
        VStack {
            SearchBarView(text: container.binding(for: \.searchText))
                .padding(.horizontal, 15)
            
            switch state.contentState {
            case .initial(let bookList), .result(let bookList):
                ScrollView(.vertical) {
                    verticalGridView(bookList: bookList)
                }
                .scrollDismissesKeyboard(.immediately)
            case .empty(let placeholder):
                PlaceholderView(text: placeholder, type: .shelf)
            }
        }
        .onAppear {
            intent.viewOnAppear()
        }
        .onChange(of: state.searchText) { newValue in
            intent.searchTextOnChanged(searchText: newValue)
        }
        .onChange(of: isActive) { newValue in
            intent.viewOnAppear()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func verticalGridView(bookList: [Book]) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 20, content: {
            let screenSize = UIScreen.main.bounds.size
            let width = (screenSize.width - 70) / 3
            let height = width * 1.5
            let size = CGSize(width: width, height: height)
            
            ForEach(bookList, id: \.id) { item in
                NavigationLinkWrapper {
                    BookReviewView.build(book: item, isActive: $isActive)
                } inner: {
                    ShelfBookView(bookList: item, size: size)
                }
            }
        })
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

extension EntireShelfView {
    static func build() -> some View {
        let model = EntireShelfModel()
        let intent = EntireShelfIntent(
            model: model,
            bookRepository: DefaultBookRepository()
        )
        let container = MVIContainer(
            intent: intent as EntireShelfIntentProtocol,
            model: model as EntireShelfModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = EntireShelfView(container: container)
        return view
    }
}
