//
//  TransportStationModel.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

struct TransportStationModel {
    var nearByStations = [StationsModel]()
    var transportType: TransportType
}

extension TransportStationModel {
    init() {
        transportType = .bus
    }
    init(with dictionary: [String: Any]) {
        if let nearStations = dictionary["nearstations"] as? [[String: Any]] {
            nearByStations = nearStations.map({ StationsModel(with: $0) })
        }
        transportType = TransportType(rawValue: dictionary.getString(forKey: "transport")) ?? .bus
    }
}
