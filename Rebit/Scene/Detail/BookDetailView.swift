//
//  BookDetailView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject private var viewModel = BookDetailViewModel()
    var book: Book
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    detailCoverImage()
                    DetailContentView(book)
                }
                .frame(minHeight: proxy.size.height)
            }
        }
        .ignoresSafeArea()
        .background(backgroundColorView())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: {
                    NavigationLazyView(BookWriteView())
                }, label: {
                    Text("저장")
                        .foregroundStyle(.black)
                })
                
            }
        }
    }
    
    func detailCoverImage() -> some View {
        CoverImageView(url: book.image)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(width: 180, height: 250)
            .offset(x: 0, y: 100)
            .zIndex(1.0)
    }
    
    func backgroundColorView() -> some View {
        CoverImageView(url: book.image)
            .frame(width: .infinity, height: .infinity)
            .blur(radius: 60)
    }
}

struct DetailContentView: View {
    var book: Book
    @State private var isOpened = false
    
    init(_ book: Book) {
        self.book = book
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(book.title)
                .font(.title3.bold())
            Text(book.author)
                .foregroundStyle(.gray)
                .font(.callout.bold())
            Divider()
            HStack(alignment: .top) {
                Text(book.description)
                    .lineLimit(isOpened ? .max : 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    isOpened.toggle()
                }, label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray)
                        .rotationEffect(
                            Angle(degrees: isOpened ? 180 : 0)
                        )
                })
                
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 120)
        .padding(.horizontal, 15)
        .background(
            Rectangle()
                .fill(.thinMaterial)
        )
    }
}


#Preview {
    BookDetailView(book: Book(
        title: "주술회전 26 (남쪽으로)",
        image: "https://shopping-phinf.pstatic.net/main_4850944/48509446622.20240618091426.jpg",
        author: "아쿠타미 게게",
        isbn: "123456789999",
        description: "고죠 VS. 스쿠나!!!\n차원이 다른 “최강”의 전투, 그 결말은?!\n\n급이 다른 규모로 펼쳐지는 고죠 VS. 스쿠나의 최강 결전…! 영역의 동시 전개와 타서 끊어진 술식의 회복을 반복하던 전투는, 마허라가 소환되고 고죠의 영역 전개가 불가능해지면서 균형이 무너진 것처럼 보이는데--?!\n\n약식판권 : JUJUTSU KAISEN ⓒ2018 by Gege Akutami / SHUEISHA Inc."
    ))
}
