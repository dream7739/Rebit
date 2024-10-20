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
    @Environment(\.colorScheme) var color

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
        .alert("review-delete-title".localized, isPresented: $isShowingAlert) {
            Button("review-delete-ok".localized, role: .none) {
                viewModel.input.deleteButtonClicked.send(reviewInfo)
            }
            
            Button("review-delete-cancel".localized, role: .cancel) { }
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 30, topTrailing: 30))
                .fill(color == .light ? .white : .black)
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
                .asContentBlackForeground()
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
                        .foregroundStyle(color == .light ? .red : .white)
                        .imageScale(.large)
                } else {
                    Image(systemName: "heart")
                        .foregroundStyle(color == .light ? .black : .white)
                        .imageScale(.large)
                }
            })
            optionMenu()
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
    
    func optionMenu() -> some View {
        Menu {
            Button("menu-edit".localized, action: {
                isFullPresented = true
            })
            
            Button("menu-delete".localized, action: {
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
                Button("menu-detail".localized, action: {})
            }
        } label: {
            Image(.dotList)
                .frame(width: 30, height: 30)
        }
    }
    
    func infoSectionView() -> some View {
        HStack {
            let status = ReadingStatus(rawValue: reviewInfo.status)?.title ?? "정보 없음"
            infoBoxView("review-status-title".localized, status)
            infoBoxView("review-rating".localized, reviewInfo.ratingDescription)
            infoBoxView("review-count".localized, viewModel.output.bookInfo.reviewCountDescription)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 65)
    }
    
    func infoBoxView(_ title: String, _ content: String) -> some View {
        Rectangle()
            .fill(color == .light ? .white : .black)
            .overlay(alignment: .center) {
                VStack(alignment: .center, spacing: 4) {
                    Text(title)
                        .asTitleGrayForeground()
                    
                    if title == "review-rating".localized && content != "-" {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.orange)
                            Text(content)
                                .font(.callout.bold())
                        }
                    } else {
                        Text(content)
                            .font(.callout.bold())
                    }
                }
            }
    }
    
    func contentSectionView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if reviewInfo.status == 0 {
                contentView("review-comment".localized, reviewInfo.title)
                contentView("review-expected-date".localized, reviewInfo.startDateDescription)
                contentView("review-save-date".localized, reviewInfo.saveDateDescription)
            } else {
                contentView("review-comment".localized, reviewInfo.title)
                contentView("review-content".localized, reviewInfo.content)
                contentView("review-date".localized, reviewInfo.readingDateDescription)
                contentView("review-save-date".localized, reviewInfo.saveDateDescription)
            }
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



