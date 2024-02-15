//
//  ErrorResponse.swift
//  
//
//  Created by Writayan Das on 06/02/24.
//

import Foundation

public enum ErrorResponse: Error {
    case noNetwork
    case invalidData
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown(Error)
}

extension ErrorResponse: LocalizedError {

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .noNetwork:
            return "No internet connection"
        case .invalidData:
            return "Error while decoding the response"
        case .invalidURL:
            return "Request can not be fulfilled"
        case .noResponse:
            return "No Reponse"
        case .unauthorized:
            return "Session expired"
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: - \(statusCode)"
        case .unknown(let error):
            return "\(error.localizedDescription)"

        }
    }
}
