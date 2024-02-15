//
//  MockDataRequest.swift
//
//
//  Created by Writayan Das on 06/02/24.
//

import Foundation
@testable import NetworkManager

struct MockResponse: Decodable, Equatable {
    let name: String
    let location: String
}

extension DataRequest {
    typealias ResponseData = MockResponse
    var url: String { "" }
    var method: HTTPMethod { .get }
    var headers: [String : String] { [:] }
    var queryItems: [String : String] { [:] }
}

struct SuccessMockDataRequest: DataRequest {
    func decode(_ data: Data) throws -> ResponseData {
        MockResponse(name: "Mock name", location: "Mock location")
    }
}

struct FailureMockDataRequest: DataRequest {
    func decode(_ data: Data) throws -> ResponseData {
        throw ErrorResponse.invalidData
    }
}
