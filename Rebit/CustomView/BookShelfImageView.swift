//
//  BookShelfImageView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct ShelfBookView: View {
    @ObservedRealmObject var bookList: BookInfo
    
    var body: some View {
        VStack {
            Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(bookList.id)") ?? UIImage())
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
