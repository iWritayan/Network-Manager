//
//  NetworkManagerTests.swift
//
//
//  Created by Writayan Das on 06/02/24.
//

import XCTest
@testable import NetworkManager

final class DataNetworkServiceTests: XCTestCase {
    var mockURLSession: URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: sessionConfiguration)
    }
    lazy var networkService = DataNetworkService(urlSession: mockURLSession)
    
    func testFetchData_URLSessionSuccessResponse() async {
        mockProtocolSuccessResponse()
        do {
            let responseData = try await networkService.fetchDataFor(request: SuccessMockDataRequest())
            XCTAssertEqual(MockResponse(name: "Mock name", location: "Mock location"), responseData)
        } catch {
            XCTFail()
        }
    }
    
    func testFetchData_URLSessionFailureResponse() async {
        do {
            mockProtocolFailureResponse()
            let _ = try await networkService.fetchDataFor(request: SuccessMockDataRequest())
        } catch {
            print(error)
            XCTAssertEqual(error.localizedDescription, ErrorResponse.unknown(error).localizedDescription)
        }
    }
    
    func testFetchData_URLSessionFailureDataRequest() async {
        do {
            mockProtocolSuccessResponse()
            let _ = try await networkService.fetchDataFor(request: FailureMockDataRequest())
        } catch {
            print(error)
            XCTAssertEqual(error.localizedDescription, ErrorResponse.invalidData.localizedDescription)
        }
    }
    
    private func mockProtocolSuccessResponse() {
        let data = mockJSONData()!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
    }
    
    private func mockProtocolFailureResponse() {
        MockURLProtocol.error = ErrorResponse.noResponse
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://www.example.com")!,
                                           statusCode: 401,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil)
        }
    }
    
    private func mockJSONData() -> Data? {
        let json = """
        {
        "name": "Mock name",
        "location" : "Mock location"
        }
        """
        return json.data(using: .utf8)
    }
}
