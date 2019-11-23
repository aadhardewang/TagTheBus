//
//  Enums.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

// For Page type
enum StationPageType: Int {
    case list = 0
    case map
}

// For Transport Type
enum TransportType: String {
    case bus = "bus"
}

enum Storyboards: String {
    case main = "Main"
}

enum CellIdentifiers: String {
    case stationList = "StationListCell"
}

enum DateFormats: String {
    case dateTime = "dd/MM/yyyy hh:mm a"
}
