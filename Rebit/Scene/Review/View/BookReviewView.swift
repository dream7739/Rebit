//
//  BookReviewView.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct BookReviewView: View {
    @StateObject private var viewModel: BookReviewViewModel
    @Environment(\.presentationMode) var presentationMode

    init(bookInfo: BookInfo) {
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
                    ForEach($viewModel.output.bookInfo.reviewList, id: \.id) { $review in
                        BookReviewContentView(
                            viewModel: viewModel,
                            reviewInfo: $review
                        )
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.input.viewOnAppear.send(())
        }
        .onReceive(viewModel.output.isReviewChanged, perform: { _ in
            if viewModel.output.bookInfo.reviewList.isEmpty {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

struct BookReviewContentView: View {
    @ObservedObject var viewModel: BookReviewViewModel
    @Binding var reviewInfo: BookReview
    @State var isFullPresented: Bool = false
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        VStack {
            headerView()
            Divider()
            infoSectionView()
            Divider()
            contentSectionView()
            Spacer()
        }
        .fullScreenCover(isPresented: $isFullPresented,
                         onDismiss: {
            viewModel.input.updateOccured.send(reviewInfo)
        }) {
            BookWriteView(
                bookReview: reviewInfo,
                isFullPresented: $isFullPresented
            )
        }
        .alert("정말 삭제하시겠습니까?", isPresented: $isShowingAlert) {
            Button("확인", role: .none) {
                viewModel.input.deleteButtonClicked.send(reviewInfo)
            }
            
            Button("취소", role: .cancel) { }
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 30, topTrailing: 30))
                .fill(.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 10, y: 5)
        )
        .padding(.trailing, 20)
        .padding(.vertical)
    }
    
    func headerView() -> some View {
        VStack {
            Image(uiImage: viewModel.output.bookCoverImage)
                .resizable()
                .frame(width: 120, height: 160)
                .padding(.top, 10)
            Text(viewModel.output.bookInfo.title)
                .font(.callout.bold())
            Text(viewModel.output.bookInfo.author)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .overlay(alignment: .topTrailing) {
            optionMenuView()
        }
    }
    
    func optionMenuView() -> some View {
        HStack(alignment: .center, spacing: 4) {
            Button(action: {
                viewModel.input.isLikeClicked.send(reviewInfo)
            }, label: {
                if reviewInfo.isLike {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        .imageScale(.large)
                } else {
                    Image(systemName: "heart")
                        .foregroundStyle(.black)
                        .imageScale(.large)
                }
            })
            Menu {
                Button("수정", action: {
                    isFullPresented = true
                })
                
                Button("삭제", action: {
                    isShowingAlert = true
                })
                
                NavigationLinkWrapper {
                    let book = viewModel.output.bookInfo
                    BookDetailView(
                        book: Book(
                            title: book.title,
                            image: "",
                            author: book.author,
                            publisher: book.publisher,
                            pubdate: book.pubdate,
                            isbn: book.isbn,
                            description: book.content),
                            coverImage: viewModel.output.bookCoverImage
                    )
                } inner: {
                    Button("상세정보", action: {})
                }
            } label: {
                Image(.dotList)
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
    
    func infoSectionView() -> some View {
        HStack {
            infoBoxView("독서기간", reviewInfo.periodDescription)
            infoBoxView("평점", reviewInfo.ratingDescription)
            infoBoxView("리뷰수", viewModel.output.bookInfo.reviewCountDescription)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
    }
    
    func infoBoxView(_ title: String, _ content: String) -> some View {
        Rectangle()
            .fill(.white)
            .overlay(alignment: .center) {
                VStack(alignment: .center, spacing: 4) {
                    Text(title)
                        .foregroundStyle(.gray)
                        .font(.caption)
                    Text(content)
                        .font(.callout.bold())
                }
            }
    }
    
    func contentSectionView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            contentView("한줄평", reviewInfo.title)
            contentView("감상평", reviewInfo.content)
            contentView("독서기간", reviewInfo.periodDescription)
            contentView("저장일", reviewInfo.saveDateDescription)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
    
    func contentView(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .asTitleGrayForeground()
            Text(content)
                .asContentBlackForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



