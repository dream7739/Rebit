//
//  APIError.swift
//  Rebit
//
//  Created by 홍정민 on 10/19/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidStatus
    case failDecoding
    case unknown
}

enum APIQueryParam: String {
    case query
    case start
    case display
}

enum APIHeader: String {
    case clientId = "X-Naver-Client-Id"
    case clientSecret = "X-Naver-Client-Secret"
}
