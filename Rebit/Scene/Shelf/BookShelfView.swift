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
            Text("지금 어떤 책을 읽고 있나요?")
                .bold()
            
            asHorizontalPageContent {
                ForEach(viewModel.currentBookList, id: \.id) { item in
                    CurrentReadingView(currentBookInfo: item)
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
                    ShelfBookView(bookList: viewModel.bookList[item])
                }
            } else {
                ForEach(viewModel.bookList, id: \.id) { item in
                    ShelfBookView(bookList: item)
                }
            }
        })
    }
}

struct CurrentReadingView: View {
    @ObservedRealmObject var currentBookInfo: BookInfo
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(currentBookInfo.id)") ?? UIImage())
                .resizable()
                .frame(width: 100, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .offset(x: -5, y: 0)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 3, y: 3)
            VStack(alignment: .leading) {
                Text(currentBookInfo.title)
                    .lineLimit(2)
                    .font(.subheadline)
                Text(currentBookInfo.author)
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()
                Button(action: {}, label: {
                    Capsule()
                        .fill(.theme.opacity(0.6))
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



#Preview {
    BookShelfView()
}
