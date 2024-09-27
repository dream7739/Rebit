//
//  BookSearchView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject private var viewModel = BookSearchViewModel()
    private var placeholderText = "책을 검색하고 리뷰를 작성해보세요"
    private var noResultPlaceholderText = "검색결과가 존재하지 않습니다"
    
    var body: some View {
        VStack {
            SearchBarView(text: $viewModel.searchText)
                .padding(.horizontal, 10)
                .onSubmit {
                    viewModel.input.callSearch.send(())
                }
            verticalScrollView()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    @ViewBuilder
    func verticalScrollView() -> some View {
        if viewModel.output.bookList.isEmpty {
            if viewModel.output.isInitial {
                PlaceholderView(text: placeholderText, type: .search)
            } else {
                PlaceholderView(text: noResultPlaceholderText, type: .shelf)
            }
        } else {
            ScrollViewReader { reader in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(Array(zip(viewModel.output.bookList.indices, viewModel.output.bookList)), id: \.0) { index, item in
                            SearchRowView(book: item)
                                .onAppear {
                                    if index == viewModel.output.bookList.count - 4 {
                                        if viewModel.isPaginationRequired {
                                            viewModel.callRequestMore()
                                        }
                                    }
                                }
                        }
                    }
                }
                .onReceive(viewModel.output.scrollToTop) { _ in
                    reader.scrollTo(0, anchor: .top)
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct SearchRowView: View {
    var book: Book
    
    var body: some View {
        NavigationLinkWrapper {
            BookDetailView(book: book)
        } inner: {
            HStack(alignment: .top, spacing: 15) {
                CoverImageView(url: book.image)
                    .frame(width: 90, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.callout.bold())
                        .lineLimit(2)
                    Text(book.author)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundStyle(.gray)
                    Spacer()
                    HStack {
                        Spacer()
                        WriteButtonView()
                    }
                }
            }
            .padding()
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        
    }
}

struct WriteButtonView: View {
    var body: some View {
        Text("기록하기")
            .font(.callout.bold())
            .frame(width: 90, height: 35)
            .background(.theme)
            .foregroundStyle(.white)
            .clipShape(
                .rect(topLeadingRadius: 0, bottomLeadingRadius: 20, bottomTrailingRadius: 15, topTrailingRadius: 15)
            )
    }
}

#Preview {
    BookSearchView()
}
