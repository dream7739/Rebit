//
//  BookShelfImageView.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct ShelfBookView: View {
    var book: Book
    var size: CGSize
    @State var coverImage = UIImage()
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                Image(uiImage: coverImage)
                    .resizable()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Text(book.title)
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
        .onAppear {
            do {
                coverImage = try ImageFileManager.shared.loadImageToDocument(filename: "\(book.id)")
            } catch {
                print(error)
            }
        }
        .frame(minWidth: size.width, minHeight: size.height)
        
    }
}
