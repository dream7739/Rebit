//
//  BookReviewContentView.swift
//  Rebit
//
//  Created by 홍정민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct BookReviewContentView: View {
    @StateObject private var viewModel: BookReviewContentViewModel
    @State var isFullPresented: Bool = false
    var image: UIImage
    
    init(reviewInfo: BookReview, image: UIImage) {
        self._viewModel = StateObject(
            wrappedValue: BookReviewContentViewModel(reviewInfo: reviewInfo)
        )
        self.image = image
    }
    
    var body: some View {
        VStack {
            headerView()
            Divider()
            infoSectionView()
            Divider()
            contentSectionView()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 30, topTrailing: 30))
                .fill(.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 10, y: 5)
        )
        .padding(.trailing, 20)
        .padding(.vertical)
        .fullScreenCover(isPresented: $isFullPresented, onDismiss: {
            viewModel.input.modifyOccured.send(())
        }) {
            BookWriteView(bookReview: viewModel.reviewInfo, isFullPresented: $isFullPresented)
        }
        .onAppear {
            viewModel.input.viewOnAppear.send(())
        }
    }
    
    func headerView() -> some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 150, height: 230)
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
                viewModel.input.isLikeClicked.send(())
            }, label: {
                if viewModel.output.reviewInfo.isLike {
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

                Button("삭제", action: {})
                
                NavigationLinkWrapper {
                    if let book = viewModel.reviewInfo.book.first {
                        BookDetailView(
                            book: Book(
                                title: book.title,
                                image: "",
                                author: book.author,
                                publisher: book.publisher,
                                pubdate: book.pubdate,
                                isbn: book.isbn,
                                description: book.content),
                            coverImage: image
                        )
                    }
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
            infoBoxView("독서기간", viewModel.output.reviewInfo.periodDescription)
            infoBoxView("평점", viewModel.output.reviewInfo.ratingDescription)
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
            contentView("한줄평", viewModel.output.reviewInfo.title)
            contentView("감상평", viewModel.output.reviewInfo.content)
            contentView("독서기간", viewModel.output.reviewInfo.periodDescription)
            contentView("저장일", viewModel.output.reviewInfo.saveDateDescription)
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



