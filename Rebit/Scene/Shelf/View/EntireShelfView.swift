//
//  EntireShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct EntireShelfView: View {
    @ObservedResults(BookInfo.self, sortDescriptor: SortDescriptor(keyPath: "saveDate", ascending: false))
    var bookList
    @State private var text = ""
    private var placeholderText = "shelf-entire-empty".localized
    
    var body: some View {
        VStack {
            SearchBarView(text: $text)
                .padding(.horizontal, 15)
            
            if bookList.isEmpty {
                PlaceholderView(text: placeholderText, type: .shelf)
            } else {
                ScrollView(.vertical) {
                    verticalGridView()
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func verticalGridView() -> some View {
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
            
            if text.isEmpty {
                ForEach(bookList, id: \.id) { item in
                    NavigationLinkWrapper {
                        BookReviewView(bookInfo: item)
                    } inner: {
                        ShelfBookView(bookList: item, size: size)
                    }
                }
            } else {
                ForEach(bookList.where { $0.title.contains(text, options: .caseInsensitive) }, id: \.id) { item in
                    NavigationLinkWrapper {
                        BookReviewView(bookInfo: item)
                    } inner: {
                        ShelfBookView(bookList: item, size: size)
                    }
                    
                }
            }
        })
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
    
}


#Preview {
    EntireShelfView()
}
