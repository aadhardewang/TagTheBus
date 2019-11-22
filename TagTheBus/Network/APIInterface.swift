//
//  APIInterface.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

class APIInterface: NSObject, APIManager {
    static let shared = APIInterface()
 
    func getNearBusStations(with latitude: Double, longitude: Double, complitionHandler: @escaping APIResponseBlock) {
        let urlString = String.init(format: TagTheBusServices.nearBusStations.path, latitude, longitude)
        performGetOperation(endPoint: urlString, showHUD: true) { (response) in
            switch response {
            case .success(let apiSuccess):
                if let data = apiSuccess.json["data"] as? [String: Any] {
                    let apiData = APISuccess(json: data, headers: apiSuccess.headers, url: apiSuccess.url)
                    complitionHandler(.success(apiData))
                } else {
                    complitionHandler(.failure(APIError(type: .invalidJSON)))
                }
            case .failure(_):
                complitionHandler(response)
            }
        }
    }
}
