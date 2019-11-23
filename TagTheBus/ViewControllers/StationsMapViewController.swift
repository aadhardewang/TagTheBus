//
//  StationsMapViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit
import MapKit

class StationsMapViewController: UIViewController {

    /// Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    let dashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    // MARK: - Custom Methods
    private func setScreenLayout() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        getNearbyStations()
    }
    
    private func addAnnotationsOnMap() {
        removeAllAnnotations()
        let stations = dashboardViewModel.transportStations.nearByStations
        if stations.count > 0 {
            let annotations = stations.map({ StationsAnnotation(station: $0) })
            mapView.addAnnotations(annotations)
        }
        zoomToFitAllAnnotations()
    }
    
    private func removeAllAnnotations() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    private func zoomToFitAllAnnotations() {
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        if annotations.count > 0 {
            mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    func updateUserLocation() {
        if let coordinate = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coordinate, animated: true)
        }
    }
    
    // MARK: - API calling
    private func getNearbyStations() {
        dashboardViewModel.getNearBusStations { (errorMessage) in
            if let message = errorMessage {
                self.displayAlert(with: "Error!", message: message, buttonTitles: ["Ok"]) { (_) in
                }
            }
            DispatchQueue.main.async {
                self.addAnnotationsOnMap()                
            }
        }
    }
}

extension StationsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kAnnotation)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: kAnnotation)
            annotationView!.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? StationsAnnotation {
            let destinationVC = StationDetailViewController.instance() as! StationDetailViewController
            destinationVC.setStationDetail(annotation.station)
            if let navigator = navigationController {
                navigator.pushViewController(destinationVC, animated: true)
            }
        }
    }
}
