//
//  StationsAnnotation.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import MapKit

class StationsAnnotation: MKPointAnnotation {

    var station: StationsModel!
    
    init(station: StationsModel) {
        super.init()
        title = station.streetName
        coordinate = station.location
        self.station = station
    }
}
