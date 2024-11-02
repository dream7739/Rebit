//
//  BookSearchRowView.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import SwiftUI

struct SearchRowView: View {
    var book: Book
    @Environment(\.colorScheme) var color
    
    var body: some View {
        NavigationLinkWrapper {
            BookDetailView(book: book)
        } inner: {
            HStack(alignment: .top, spacing: 15) {
                CoverImageView(url: book.image)
                    .frame(width: 90, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.callout.bold())
                        .lineLimit(2)
                    Text(book.author)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundStyle(.gray)
                    Spacer()
                    HStack {
                        Spacer()
                        WriteButtonView()
                    }
                }
            }
            .padding()
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color == .light ? .white : .black)
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
    }
}
