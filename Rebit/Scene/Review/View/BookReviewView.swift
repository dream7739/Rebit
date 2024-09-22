//
//  BookReviewView.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct BookReviewView: View {
    @ObservedRealmObject var bookInfo: BookInfo
    @StateObject private var viewModel: BookReviewViewModel
    
    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        self._viewModel = StateObject(wrappedValue: BookReviewViewModel(bookInfo: bookInfo))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    .theme.opacity(0.3)
                )
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                asHorizontalPageContent(height: proxy.size.height) {
                    ForEach(viewModel.bookInfo.reviewList, id: \.id) { review in
                        BookReviewContentView(
                            reviewInfo: review,
                            image: viewModel.output.bookCoverImage
                        )
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.input.viewOnAppear.send(())
        }
    }
}
