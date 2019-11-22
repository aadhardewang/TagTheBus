//
//  APIManager.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

protocol APIManager: NetworkHttpClient {

    func performGetOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)

    func performPostOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)

    func performPutOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)

    func performDeleteOperation(endPoint: String, parameters: [String: Any], headers: [String: String], showHUD: Bool, completionHandler: @escaping APIResponseBlock)
}


extension APIManager {
    
    func performGetOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.isNetworkRechable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        if showHUD {
//            SVProgressHUD.show()
        }
        callRestAPIWith(endPoint, httpMethod: .get, parameters: parameters, headers: headers) { (response) in
            if showHUD {
//                SVProgressHUD.dismiss()
            }
            completionHandler(response)
        }
    }
    
    func performPostOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.isNetworkRechable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        if showHUD {
//            SVProgressHUD.show()
        }
        callRestAPIWith(endPoint, httpMethod: .post, parameters: parameters, headers: headers) { (response) in
            if showHUD {
//                SVProgressHUD.dismiss()
            }
            completionHandler(response)
        }
    }
    
    func performPutOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.isNetworkRechable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        if showHUD {
//            SVProgressHUD.show()
        }
        callRestAPIWith(endPoint, httpMethod: .put, parameters: parameters, headers: headers) { (response) in
            if showHUD {
//                SVProgressHUD.dismiss()
            }
            completionHandler(response)
        }
    }
    
    func performDeleteOperation(endPoint: String, parameters: [String: Any] = [:], headers: [String: String] = [:], showHUD: Bool = true, completionHandler: @escaping APIResponseBlock) {
        if !ReachabilityManager.isNetworkRechable {
            completionHandler(.failure(APIError(type: .noNetwork)))
            return
        }
        if showHUD {
//            SVProgressHUD.show()
        }
        callRestAPIWith(endPoint, httpMethod: .delete, parameters: parameters, headers: headers) { (response) in
            if showHUD {
//                SVProgressHUD.dismiss()
            }
            completionHandler(response)
        }
    }
    
}
