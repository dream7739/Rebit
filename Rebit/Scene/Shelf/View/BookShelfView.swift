//
//  BookShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    
    @ObservedResults(
        BookReview.self,
        where: ({ $0.status == 0 }),
        sortDescriptor: SortDescriptor(keyPath: "saveDate", ascending: false)
    )
    var expectedReviewList
    
    @ObservedResults(
        BookInfo.self,
        sortDescriptor: SortDescriptor(keyPath: "saveDate", ascending: false)
    )
    var bookList
    
    private var placeholderText = "shelf-my-empty".localized
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                nowReadingSection(proxy.size.height * 0.3)
                mybookShelfSection(proxy.size.height * 0.6)
                Spacer()
            }
            .padding()
        }
        .onAppear {
            print(Realm.Configuration.defaultConfiguration.fileURL)
        }
    }
    
    func nowReadingSection(_ height: CGFloat) -> some View {
        VStack(alignment: .leading) {
            Text("shelf-announce".localized)
                .font(.callout)
                .bold()
            
            asHorizontalPageContent(height: height * 0.9) {
                if expectedReviewList.isEmpty {
                    Text("shelf-announce-empty".localized)
                        .foregroundStyle(.gray)
                        .font(.callout)
                        .frame(maxHeight: height * 0.9, alignment: .center)
                } else {
                    ForEach(expectedReviewList, id: \.id) { item in
                        NavigationLinkWrapper {
                            if let book = item.book.first {
                                BookReviewView(bookInfo: book)
                            }
                        } inner: {
                            ExpectedReadingView(reviewInfo: item)

                        }
                    }

                }
            }
        }
        .frame(height: height)
    }
    
    func mybookShelfSection(_ height: CGFloat) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("shelf-my".localized)
                    .bold()
                    .font(.callout)
                Spacer()
                NavigationLinkWrapper {
                    EntireShelfView()
                } inner: {
                    Text("shelf-detail".localized)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            shelfGridView()
        }
        .frame(minHeight: height)
    }
    
    func shelfGridView() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return GeometryReader { proxy in
            let height = (proxy.size.height / 2) - 20
            let width = height / 1.5
            let size = CGSize(width: width, height: height)
            
            if bookList.isEmpty {
                PlaceholderView(text: placeholderText, type: .shelf)
            } else {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    if bookList.count >= 6 {
                        ForEach(0..<6) { item in
                            NavigationLinkWrapper {
                                BookReviewView(bookInfo: bookList[item])
                            } inner: {
                                ShelfBookView(bookList: bookList[item], size: size)
                            }
                        }
                    } else {
                        ForEach(bookList, id: \.id) { item in
                            NavigationLinkWrapper {
                                BookReviewView(bookInfo: item)
                            } inner: {
                                ShelfBookView(bookList: item, size: size)
                            }
                        }
                    }
                })
            }
        }
    }
}

struct ExpectedReadingView: View {
    var reviewInfo: BookReview
    
    var body: some View {
        if let bookInfo = reviewInfo.book.first {
            GeometryReader { proxy in
                let height = proxy.size.height - 20
                let width = height / 1.4
                
                HStack(alignment: .top) {
                    Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(bookInfo.id)") ?? UIImage())
                        .resizable()
                        .frame(width: width, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(x: -5, y: 0)
                        .shadow(color: .gray.opacity(0.3), radius: 10, x: 3, y: 3)
                    VStack(alignment: .leading) {
                        Text(bookInfo.title)
                            .lineLimit(1)
                            .font(.subheadline)
                        Text(bookInfo.author)
                            .asTitleGrayForeground()
                        Text("\(reviewInfo.title)")
                            .asTitleGrayForeground()
                            .lineLimit(2)
                        Spacer()
                        Text("shelf-write-review".localized)
                            .asGreenCapsuleBackground()
                    }
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
            }
        }
    }
    
}



#Preview {
    BookShelfView()
}
