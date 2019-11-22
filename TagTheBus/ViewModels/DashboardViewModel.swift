//
//  DashboardViewModel.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class DashboardViewModel: NSObject {
    
    var transportStations = TransportStationModel()
    
    func getNearBusStations(complitionHandler: @escaping (String?) -> Void) {
        APIInterface.shared.getNearBusStations(with: 41.3985182, longitude: 2.1917991) { (response) in
            switch response {
            case .success(let apiSuccess):
                self.transportStations = TransportStationModel(with: apiSuccess.json)
                complitionHandler(nil)
            case .failure(let apiError):
                complitionHandler(apiError.message)
            }
        }
    }
}
