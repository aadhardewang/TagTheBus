//
//  StationDetailViewModel.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class StationDetailViewModel: NSObject {
    
    var stationDetails: StationsModel?
    var stationImageDetails = [StationImageDetailModel]()

    func getStationImageDetails() {
        if let stationDetails = self.stationDetails {
            stationImageDetails = DatabaseManager.shared.getImageDetails(from: stationDetails.id)
        }
    }
    
    func addImageDetail(_ stationImageDetail: StationImageDetailModel) {
        stationImageDetails.append(stationImageDetail)
    }
}
