//
//  APIResponse.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

typealias APIResponseBlock = (APIResponse) -> Void

enum APIResponse {
    case success(APISuccess)
    case failure(APIError)
}

struct APISuccess {
    var json: [String: Any]
    var headers: [String: Any]
    var url: URL?
}

struct APIError {
    var message: String
    var type: APIErrorType
    var statusCode: Int
}

extension APIError {
    init(type: APIErrorType) {
        self.message = type.getMessage()
        self.type = type
        self.statusCode = 0
    }
}

enum APIErrorType {
    case invalidURL
    case invalidHeaderValue
    case noData
    case conversionFailed
    case invalidJSON
    case invalidResponse
    case noNetwork
    case customAPIError
    
    func getMessage() -> String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidHeaderValue: return "Header value is not string"
        case .noData: return "No Data available"
        case .conversionFailed: return "Conversion Failed"
        case .invalidJSON: return "Invalid JSON"
        case .invalidResponse: return "Invalid Response"
        case .noNetwork: return "Please check your internet connection."
        case .customAPIError: return ""
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
