//
//  EntireShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct EntireShelfView: View {
    @State var text = ""
    
    @ObservedResults(BookInfo.self)
    var bookList
    
    var body: some View {
        VStack {
            SearchBarView(text: $text)
                .padding(.horizontal, 15)
            ScrollView(.vertical) {
                verticalGridView()
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
            if text.isEmpty {
                ForEach(bookList, id: \.id) { item in
                    NavigationLinkWrapper {
                        BookReviewView(bookInfo: item)
                    } inner: {
                        ShelfBookView(bookList: item)
                    }
                }
            } else {
                ForEach(bookList.where { $0.title.contains(text, options: .caseInsensitive) }, id: \.id) { item in
                    NavigationLinkWrapper {
                        BookReviewView(bookInfo: item)
                    } inner: {
                        ShelfBookView(bookList: item)
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
