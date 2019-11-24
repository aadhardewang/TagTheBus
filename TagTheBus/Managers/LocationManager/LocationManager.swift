//
//  LocationManager.swift
//  TagTheBus
//
//  Created by Aadhar on 24/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerProtocol: NSObjectProtocol {
    func didUpdateLocation(_ lastLocation: CLLocation)
    func didChangeAuthorization(_ status: CLAuthorizationStatus)
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    weak var delegate: LocationManagerProtocol?
    
    var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            return false
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        if let location = locationManager.location {
            return location.coordinate
        } else {
            return kCLLocationCoordinate2DInvalid
        }
    }
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            delegate?.didUpdateLocation(lastLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status)
    }
}
