//
//  ExpectedReadingView.swift
//  Rebit
//
//  Created by 홍정민 on 2/26/25.
//

import SwiftUI

struct ExpectedReadingView: View {
    var bookReviewContent: BookReviewContent
    private var book: Book { bookReviewContent.book }
    private var review: BookReview { bookReviewContent.bookReview }
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height - 20
            let width = height / 1.4
            
            HStack(alignment: .top) {
                Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(book.id)") ?? UIImage())
                    .resizable()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 3, y: 3)
                VStack(alignment: .leading) {
                    Text(book.title)
                        .lineLimit(1)
                        .font(.subheadline)
                    Text(book.author)
                        .asTitleGrayForeground()
                    Text(review.title)
                        .asTitleGrayForeground()
                        .lineLimit(2)
                    Spacer()
                    Text("shelf-write-review".localized)
                        .asGreenCapsuleBackground()
                }
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.trailing, 15)
        }
    }
    
}
