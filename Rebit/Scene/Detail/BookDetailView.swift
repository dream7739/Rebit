//
//  BookDetailView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI

struct BookDetailView: View {
    @State private var isFullPresented = false
    var book: Book
    var coverImage: UIImage?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.theme
                    .opacity(0.3)
                
                ScrollView {
                    VStack(spacing: 30) {
                        if let coverImage {
                            existCoverImage(coverImage)
                        } else {
                            asyncCoverImage()
                        }
                        DetailContentView(book)
                    }
                    .frame(minHeight: proxy.size.height)
                }
                .overlay(alignment: .bottomTrailing) {
                    writeButton()
                }
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isFullPresented, content: {
            NavigationLazyView(BookWriteView(book: book, isFullPresented: $isFullPresented))
        })
    }
    
    func asyncCoverImage() -> some View {
        CoverImageView(url: book.image)
            .frame(width: 150, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .offset(x: 0, y: 100)
            .zIndex(1.0)
    }
    
    func existCoverImage(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 150, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .offset(x: 0, y: 100)
            .zIndex(1.0)
    }
    
    func writeButton() -> some View {
        Button(action: {
            isFullPresented = true
        }, label: {
            Image(systemName: "pencil")
                .resizable()
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .padding()
                .background(.theme)
                .clipShape(Circle())
        })
        .padding(.bottom, 30)
        .padding(.trailing, 20)
    }
}

struct DetailContentView: View {
    var book: Book
    @State private var isOpened = false
    @Environment(\.colorScheme) var color
    
    init(_ book: Book) {
        self.book = book
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView()
            Divider()
            storylineView()
            publishInfoView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 90)
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
        .background(
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30, topTrailing: 30))
                .fill(color == .light ? .white : .black)
        )
    }
    
    func headerView() -> some View {
        VStack(spacing: 4) {
            Text(book.title)
                .font(.callout.bold())
            Text(book.author)
                .asContentBlackForeground()
        }
        .frame(maxWidth: .infinity)
    }
    
    func storylineView() -> some View {
        VStack(alignment: .leading) {
            Text("줄거리")
                .asTitleGrayForeground()
                .padding(.top, 5)
            HStack(alignment: .top) {
                Text(book.description)
                    .asContentBlackForeground()
                    .lineLimit(isOpened ? .max : 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    isOpened.toggle()
                }, label: {
                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                        .foregroundStyle(.gray)
                        .rotationEffect(
                            Angle(degrees: isOpened ? 180 : 0)
                        )
                })
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 5)
    }
    
    func publishInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading, spacing: 2) {
                Text("출판사")
                    .asTitleGrayForeground()
                Text(book.publisher)
                    .asContentBlackForeground()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("출판일")
                    .asTitleGrayForeground()
                Text(book.dateDescription)
                    .asContentBlackForeground()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("ISBN")
                    .asTitleGrayForeground()
                Text(book.isbn)
                    .asContentBlackForeground()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

