//
//  MockAPIManager.swift
//  Rebit
//
//  Created by 홍정민 on 10/21/24.
//

import Foundation

final class MockAPIManager: NetworkType {
    static let shared = MockAPIManager()
    private init() { }
    
    func callRequest(request: BookRequest) async throws -> BookResponse {
        return BookResponse(
            total: 10,
            start: 1,
            display: 30,
            items: [Book(
                title: "제목",
                image: "이미지",
                author: "작가",
                publisher: "출판사",
                pubdate: "2024.03.11",
                isbn: "9791136788474",
                description: "줄거리"
            )]
        )
    }
}
