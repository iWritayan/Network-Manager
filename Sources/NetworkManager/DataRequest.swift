//
//  DataRequest.swift
//  
//
//  Created by Writayan Das on 06/02/24.
//

import Foundation

public protocol DataRequest {
    associatedtype ResponseData: Decodable

    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }

    func decode(_ data: Data) throws -> ResponseData
}

public extension DataRequest {

    func decode(_ data: Data) throws -> ResponseData {
        let decoder = JSONDecoder()
        return try decoder.decode(ResponseData.self, from: data)
    }

    func getURLRequest() -> URLRequest? {
        guard var urlComponent = URLComponents(string: url) else {
            return nil
        }

        urlComponent.queryItems = getQueryItems(queryItemsURL: queryItems)

        guard let url = urlComponent.url else {
           return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }

    private func getQueryItems(queryItemsURL: [String: String]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItemsURL.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }
        return queryItems
    }
}
