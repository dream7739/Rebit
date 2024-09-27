//
//  FavoriteBookView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct FavoriteBookView: View {
    @ObservedResults(BookReview.self, where: { $0.isLike } )
    var favorite
    
    @State private var currentIndex: Int = 0
    @State private var placeholderText = "리뷰를 작성하고 좋아요한 책에 추가해보세요"
    
    var body: some View {
        if favorite.count == 0 {
            PlaceholderView(text: $placeholderText, type: .shelf)
        } else {
            ZStack(alignment: .top) {
                ForEach(Array(zip(favorite.indices, favorite)), id: \.0) {
                    (index: Int, item: BookReview) in
                    
                    NavigationLinkWrapper {
                        if let book = item.book.first {
                            BookReviewView(bookInfo: book)
                        }
                    } inner: {
                        FavoriteContentView(currentIndex: currentIndex, index: index, item: item)
                            .gesture (
                                DragGesture()
                                    .onEnded { value in
                                        let threshold: CGFloat = 50
                                        if value.translation.width > threshold {
                                            withAnimation {
                                                currentIndex = max(0, currentIndex - 1)
                                            }
                                        } else if value.translation.width < -threshold {
                                            withAnimation {
                                                currentIndex = min(favorite.count - 1, currentIndex + 1)
                                            }
                                        }
                                    }
                            )
                    }
                }
            }
        }
    }
    
}

struct FavoriteContentView: View {
    var currentIndex: Int
    var index: Int
    var item: BookReview
    
    @GestureState var dragOffset: CGFloat = 0
    var widthRatio = 2.3
    var heightRatio = 0.8
    
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.height * heightRatio) / widthRatio
            let height = proxy.size.height * heightRatio
            
            VStack(alignment: .center, spacing: 10) {
                headerView(width, height)
                descriptionView()
                Spacer()
            }
            .frame(width: width, height: height)
            .frame(maxWidth: .infinity, alignment: .center)
            .offset(x: CGFloat(index - currentIndex) * width + dragOffset, y: 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func headerView(_ width: CGFloat, _ height: CGFloat) -> some View {
        VStack(alignment: .center, spacing: 6) {
            if let book = item.book.first {
                Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(book.id)") ?? UIImage())
                    .resizable()
                    .frame(width: width , height: height * 0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(currentIndex == index ? 1.0 : 0.6)
                    .scaleEffect(currentIndex == index ? 1.0 : 0.7)
                    .padding(.bottom, 10)
                Text(book.title)
                    .font(.callout)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .bold()
                    .opacity(currentIndex == index ? 1 : 0)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .opacity(currentIndex == index ? 1 : 0)
            }
            
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.orange)
                Text(item.ratingDescription)
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            .opacity(currentIndex == index ? 1 : 0)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func descriptionView() -> some View {
        VStack(alignment: .center) {
            Text(item.content)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
                .foregroundColor(.gray)
                .font(.subheadline)
                .opacity(currentIndex == index ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    FavoriteBookView()
}
