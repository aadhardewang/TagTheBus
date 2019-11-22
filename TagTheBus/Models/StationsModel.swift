//
//  StationsModel.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation
import CoreLocation

struct StationsModel {
    var id: Int
    var streetName: String
    var city: String
    var utmX: String
    var utmY: String
    var location: CLLocationCoordinate2D
    var furniture: String
    var buses: String
    var distance: Double
}

extension StationsModel {
    init(with dictionary: [String: Any]) {
        id = dictionary.getInt(forKey: "id")
        streetName = dictionary.getString(forKey: "street_name")
        city = dictionary.getString(forKey: "city")
        utmX = dictionary.getString(forKey: "utm_x")
        utmY = dictionary.getString(forKey: "utm_y")
        let latitude = dictionary.getDouble(forKey: "lat")
        let longitude = dictionary.getDouble(forKey: "lon")
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        furniture = dictionary.getString(forKey: "furniture")
        buses = dictionary.getString(forKey: "buses")
        distance = dictionary.getDouble(forKey: "distance")
    }
}
