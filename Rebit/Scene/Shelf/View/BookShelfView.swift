//
//  BookShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    @ObservedObject private var viewModel = BookShelfViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            nowReadingSection()
            mybookShelfSection()
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            print(Realm.Configuration.defaultConfiguration.fileURL)
        })
    }
    
    func nowReadingSection() -> some View {
        VStack(alignment: .leading) {
            Text("책을 읽고 기록해보세요")
                .bold()
            
            asHorizontalPageContent(height: 150) {
                ForEach(viewModel.currentBookList, id: \.id) { item in
                    ExpectedReadingView(reviewInfo: item)
                }
            }
            
        }
    }
    
    func mybookShelfSection() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("나만의 책장")
                    .bold()
                Spacer()
                NavigationLink(destination: {
                    EntireShelfView()
                }, label: {
                    Text("더보기")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                })
                .buttonStyle(PlainButtonStyle())
            }
            shelfGridView()
        }
    }
    
    func shelfGridView() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 20, content: {
            if viewModel.bookList.count >= 6 {
                ForEach(0..<6) { item in
                    NavigationLinkWrapper {
                        BookReviewView(bookInfo: viewModel.bookList[item])
                    } inner: {
                        ShelfBookView(bookList: viewModel.bookList[item])
                    }
                }
            } else {
                ForEach(viewModel.bookList, id: \.id) { item in
                    NavigationLinkWrapper {
                        BookReviewView(bookInfo: item)
                    } inner: {
                        ShelfBookView(bookList: item)
                    }
                }
            }
        })
    }
}

struct ExpectedReadingView: View {
    @ObservedRealmObject var reviewInfo: BookReview
    
    var body: some View {
        if let bookInfo = reviewInfo.book.first {
            HStack(alignment: .top) {
                Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(bookInfo.id)") ?? UIImage())
                    .resizable()
                    .frame(width: 100, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .offset(x: -5, y: 0)
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 3, y: 3)
                VStack(alignment: .leading) {
                    Text(bookInfo.title)
                        .lineLimit(1)
                        .font(.subheadline)
                    Text(bookInfo.author)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("\(reviewInfo.title)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                    Spacer()
                    Button(action: {}, label: {
                        Capsule()
                            .fill(.theme)
                            .frame(width: 70, height: 30)
                            .overlay(alignment: .center) {
                                Text("기록하기")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            }
                    })
                }
                Spacer()
            }
            .padding()
        }
    }
    
}



#Preview {
    BookShelfView()
}
