//
//  EntireShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct EntireShelfView: View {
    @StateObject private var viewModel: EntireShelfViewModel

    init() {
        self._viewModel = StateObject(wrappedValue: EntireShelfViewModel())
    }
    
    var body: some View {
        VStack {
            SearchBarView(text: $viewModel.input.text.value)
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
            ForEach(viewModel.output.bookList, id: \.id) { item in
                NavigationLinkWrapper {
                    BookReviewView(bookInfo: item)
                } inner: {
                    ShelfBookView(bookList: item)
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
