//
//  TagTheBusServices.swift
//  TagTheBus
//
//  Created by Aadhar on 22/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

enum TagTheBusServices: String {
    case nearBusStations = "bus/nearstation/latlon/%f/%f/1.json"
    var path: String  {
        return "http://barcelonaapi.marcpous.com/" + rawValue
    }
    
}
