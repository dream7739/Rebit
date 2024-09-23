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
                .fill(.white)
        )
    }
    
    func headerView() -> some View {
        VStack {
            Text(book.title)
                .font(.callout.bold())
            Text(book.author)
                .foregroundStyle(.gray)
                .font(.subheadline.bold())
        }
        .frame(maxWidth: .infinity)
    }
    
    func storylineView() -> some View {
        VStack(alignment: .leading) {
            Text("줄거리")
                .font(.footnote)
                .padding(.top, 5)
            HStack(alignment: .top) {
                Text(book.description)
                    .font(.footnote)
                    .foregroundStyle(.gray)
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
        
    }
    
    func publishInfoView() -> some View {
        VStack(alignment: .leading) {
            Text("출판사")
                .font(.footnote)
                .padding(.top, 5)
            Text(book.publisher)
                .font(.footnote)
                .foregroundStyle(.gray)
            Text("출판일")
                .font(.footnote)
                .padding(.top, 5)
            Text(book.dateDescription)
                .font(.footnote)
                .foregroundStyle(.gray)
            Text("ISBN")
                .font(.footnote)
                .padding(.top, 5)
            Text(book.isbn)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


#Preview {
    BookDetailView(book: bookDump)
}

var bookDump = Book(
    title: "주술회전 26 (남쪽으로)",
    image: "https://shopping-phinf.pstatic.net/main_4850944/48509446622.20240618091426.jpg",
    author: "아쿠타미 게게",
    publisher: "한국문화사",
    pubdate: "20240202",
    isbn: "123456789999",
    description: "고죠 VS. 스쿠나!!!\n차원이 다른 “최강”의 전투, 그 결말은?!\n\n급이 다른 규모로 펼쳐지는 고죠 VS. 스쿠나의 최강 결전…! 영역의 동시 전개와 타서 끊어진 술식의 회복을 반복하던 전투는, 마허라가 소환되고 고죠의 영역 전개가 불가능해지면서 균형이 무너진 것처럼 보이는데--?!\n\n약식판권 : JUJUTSU KAISEN ⓒ2018 by Gege Akutami / SHUEISHA Inc."
)
