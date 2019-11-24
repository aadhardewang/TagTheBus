//
//  Enums.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

enum StationPageType: Int {
    case list = 0
    case map
}

enum TransportType: String {
    case bus = "bus"
}

enum Storyboards: String {
    case main = "Main"
}

enum CellIdentifiers: String {
    case stationList = "StationListCell"
}

enum AnnotationsIdentifiers: String {
    case stations = "StationsAnnotation"
}

enum DateFormats: String {
    case dateTime = "dd/MM/yyyy hh:mm a"
}
