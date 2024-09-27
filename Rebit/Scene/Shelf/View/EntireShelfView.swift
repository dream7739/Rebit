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
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                SearchBarView(text: $text)
                    .padding(.horizontal, 15)
                ScrollView(.vertical) {
                    verticalGridView(proxy.size)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func verticalGridView(_ size: CGSize) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return
            LazyVGrid(columns: columns, spacing: 20, content: {
                let height = (size.height / 4) - 20
                let width = height / 1.5
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
