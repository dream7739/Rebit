//
//  BookReviewContent.swift
//  Rebit
//
//  Created by 홍정민 on 3/11/25.
//

import Foundation

// MARK: 해당 모델은 책 1권과 리뷰 1건을 매치시켜서 출력해야할 때 사용
struct BookReviewContent: Hashable, Identifiable {
    let id = UUID()
    let book: Book
    let bookReview: BookReview
}
