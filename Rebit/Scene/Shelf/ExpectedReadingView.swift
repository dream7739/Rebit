//
//  ExpectedReadingView.swift
//  Rebit
//
//  Created by 홍정민 on 2/26/25.
//

import SwiftUI

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
