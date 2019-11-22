//
//  NetworkHttpClient.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

protocol NetworkHttpClient {
    func callRestAPIWith(_ strURL: String, httpMethod: HTTPMethod, parameters: [String: Any], headers: [String: String], completionHandler: @escaping APIResponseBlock)
}

extension NetworkHttpClient {
    
    func callRestAPIWith(_ strURL: String, httpMethod: HTTPMethod, parameters: [String: Any], headers: [String: String], completionHandler: @escaping APIResponseBlock) {
        if let request = enqueueRequestWith(strURL, httpMethod: httpMethod, parameters: parameters, headers: headers) {
            enqueueDataTaskWith(request, completionHandler: completionHandler)
        } else {
            completionHandler(.failure(APIError(type: .invalidURL)))
        }
    }
    
    private func enqueueRequestWith(_ strURL: String, httpMethod: HTTPMethod, parameters: [String: Any], headers: [String: String]) -> URLRequest? {
        guard let url = URL(string: strURL) else {
            return nil
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        switch httpMethod {
        case .post:
            if let jsonData = JSONEncode(url: url, parameters: parameters) {
                request.httpBody = jsonData
            }
        case .put:
            if parameters.count > 0 {
                request.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
            }
        case .delete:
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters) {
                request.httpBody = jsonData
            }
        case .get:
            if let encodedURL = URLEncode(url: url, parameters: parameters) {
                request.url = encodedURL
            }
        }
        return request
    }
    
    private func enqueueDataTaskWith(_ request: URLRequest, completionHandler: @escaping APIResponseBlock) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, urlResponse, error) -> Void in
            var statusCode = Int.max
            var allHeaderFields = [String: Any]()
            if let httpResponse = urlResponse as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                allHeaderFields = (httpResponse.allHeaderFields as? [String: Any]) ?? [:]
            }
            DispatchQueue.main.async {
                if let data = data, 200 ... 299 ~= statusCode {
                    if let response = data.dictionary {
                        let successResponse = APISuccess(json: response, headers: allHeaderFields, url: urlResponse?.url)
                        completionHandler(.success(successResponse))
                    } else {
                        completionHandler(.failure(APIError(type: .invalidJSON)))
                    }
                } else if let error = error {
                    let apiError = APIError(message: error.localizedDescription, type: APIErrorType.customAPIError, statusCode: statusCode)
                    completionHandler(.failure(apiError))
                } else if data == nil {
                    completionHandler(.failure(APIError(type: .noData)))
                } else if let data = data, let stringData = String(data: data, encoding: .utf8) {
                    let apiError = APIError(message: stringData, type: APIErrorType.customAPIError, statusCode: statusCode)
                    completionHandler(.failure(apiError))
                } else {
                    completionHandler(.failure(APIError(type: .invalidResponse)))
                }
            }
        })
        dataTask.resume()
    }
    
    //MARK: - Encoding
    
    private func URLEncode(url: URL, parameters: [String: Any] = [:]) -> URL? {
        guard !parameters.isEmpty else {
            return nil
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            return urlComponents.url
        }
        return nil
    }
    
    private func JSONEncode(url: URL, parameters: [String: Any]?) -> Data? {
        guard parameters != nil else {
            return nil
        }
        guard !parameters!.isEmpty else {
            return nil
        }
        return query(parameters!).data(using: .utf8, allowLossyConversion: false)!
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBoolean {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }
    
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
}

extension NSNumber {
    fileprivate var isBoolean: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
