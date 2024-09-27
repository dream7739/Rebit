//
//  BookShelfImageView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct ShelfBookView: View {
    var bookList: BookInfo
    var size: CGSize
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(bookList.id)") ?? UIImage())
                    .resizable()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Text(bookList.title)
                    .lineLimit(1)
                    .font(.footnote)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 2)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 3)
                        .fill(.thickMaterial)
                        .shadow(color: .gray.opacity(0.3), radius: 10, x: 5, y: 5)
                    )
                    .offset(x: 0, y: -30)
            }
        }
        .frame(minWidth: size.width, minHeight: size.height)
    }
}
