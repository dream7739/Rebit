//
//  BookShelfView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct BookShelfView: View {
    @StateObject private var viewModel = BookShelfViewModel()
    @ObservedResults(BookInfo.self, sortDescriptor: SortDescriptor(keyPath: "saveDate", ascending: false))
    var bookList
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("지금 어떤 책을 읽고 있나요?")
                .bold()
            CurrentBookView()
            
            Text("나만의 책장을 구경해볼까요")
                .bold()
            shelfGridView()
            Spacer()
        }
        .padding()
    }
    
    func shelfGridView() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 20, content: {
            ForEach(0..<6) { item in
                ShelfBookView(viewModel: viewModel, bookList: bookList[item])
            }
        })
    }
}

struct CurrentBookView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .frame(height: 160)
                .shadow(color: .gray.opacity(0.3), radius: 5)
            
            HStack(alignment: .top) {
                CoverImageView(url: "https://shopping-phinf.pstatic.net/main_5003270/50032709645.20240828201557.jpg")
                    .scaledToFit()
                    .frame(width: 100, height: 130)
                VStack(alignment: .leading) {
                    Text("주술회전 27(트리플특장판) (바보 서바이버!!)")
                    Text("아쿠타미 게게")
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ShelfBookView: View {
    @ObservedObject var viewModel: BookShelfViewModel
    @ObservedRealmObject var bookList: BookInfo
    
    var body: some View {
        VStack {
            Image(uiImage: viewModel.retriveImage("\(bookList.id)"))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text(bookList.title)
                .lineLimit(1)
                .font(.caption)
                .background(RoundedRectangle(cornerRadius: 3)
                    .fill(.thickMaterial)
                    .frame(width: 110, height: 35)
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 5, y: 5)
                )
                .offset(x: 0, y: -10)
        }
        .frame(width: 100, height: 150)
    }
}

#Preview {
    BookShelfView()
}
