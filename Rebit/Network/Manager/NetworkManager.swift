//
//  NetworkManager.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import Foundation

protocol NetworkManager {
    associatedtype Request
    associatedtype Response
    func callRequest(request: Request) async throws -> Response
}

final class APIManager: NetworkManager {
    static let shared = APIManager()
    private init() { }
    
    func callRequest(request: BookRequest) async throws -> BookResponse {
        //URLComponent
        var component = URLComponents(string: APIURL.naver)!
        
        let query = URLQueryItem(
            name: APIQueryParam.query.rawValue,
            value: request.query
        )
        let start = URLQueryItem(
            name: APIQueryParam.start.rawValue,
            value: "\(request.start)"
        )
        let display = URLQueryItem(
            name: APIQueryParam.display.rawValue,
            value: "\(request.display)"
        )
        
        component.queryItems = [query, start, display]
        
        //URLComponent > URL
        guard let url = component.url else {
            throw APIError.invalidURL
        }
        
        //URLRequest
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = [
            APIHeader.clientId.rawValue : APIKey.clientID,
            APIHeader.clientSecret.rawValue: APIKey.clientSecret
        ]
        
        //Wait async task
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatus
        }
        
        guard let decodedData = try? JSONDecoder().decode(BookResponse.self, from: data) else {
            throw APIError.failDecoding
        }
        
        return decodedData
    }
}
