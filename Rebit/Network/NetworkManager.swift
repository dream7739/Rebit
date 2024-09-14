//
//  NetworkManager.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import Foundation
import Combine

struct APIManager {
    private init() { }
    
    enum APIError: Error {
        case invalidStatus
        case failDecoding
        case unknown
    }
    
    static func fetchBooks(request: BookRequest) -> AnyPublisher<BookResponse, Error> {
        var component = URLComponents(string: APIURL.naver)!
        let query = URLQueryItem(name: "query", value: request.query)
        let start = URLQueryItem(name: "start", value: "\(request.start)")
        let display = URLQueryItem(name: "display", value: "\(request.display)")
        
        component.queryItems = [query, start, display]
        
        let url = component.url!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [
            "X-Naver-Client-Id" : APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        return URLSession.DataTaskPublisher(request: urlRequest, session: .shared)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.invalidStatus
                }
                
                guard let decodedData = try? JSONDecoder().decode(BookResponse.self, from: data) else {
                    throw APIError.failDecoding
                }
                
                return decodedData
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
        
    }
}
