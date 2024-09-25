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
    @State private var isFullPresented = false
    @State private var presentedReview = BookReview()

    init(bookInfo: BookInfo) {
        self.bookInfo = bookInfo
        self._viewModel = StateObject(wrappedValue: BookReviewViewModel(bookInfo: bookInfo))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    .theme.opacity(0.4)
                )
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                asHorizontalPageContent(height: proxy.size.height) {
                    ForEach(viewModel.bookInfo.reviewList, id: \.id) { review in
                        BookReviewContentView(
                            reviewInfo: review,
                            isFullPresented: $isFullPresented,
                            image: viewModel.output.bookCoverImage
                        )
                        .onAppear {
                            presentedReview = review
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.input.viewOnAppear.send(())
        }
        .fullScreenCover(isPresented: $isFullPresented) {
            BookWriteView(bookReview: presentedReview, isFullPresented: $isFullPresented)
        }
    }
}
