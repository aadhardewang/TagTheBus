//
//  StationsListViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class StationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNearbyStations()
    }
    
    // MARK: - API calling
    private func getNearbyStations() {
        dashboardViewModel.getNearBusStations { (errorMessage) in
            if let message = errorMessage {
                self.displayAlert(with: "Error!", message: message, buttonTitles: ["Ok"]) { (_) in
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.dashboardViewModel.transportStations.nearByStations.count == 0 ? self.tableView.displayBackground(text: "No Stations Available") : self.tableView.removeBackgroundText()
                self.tableView.tableFooterView = UIView()
            }
        }
    }
}

extension StationsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardViewModel.transportStations.nearByStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.stationList.rawValue)
        let station = dashboardViewModel.transportStations.nearByStations[indexPath.row]
        cell?.textLabel?.text = station.streetName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = StationDetailViewController.instance() as! StationDetailViewController
        destinationVC.setStationDetail(dashboardViewModel.transportStations.nearByStations[indexPath.row])
        if let navigator = navigationController {
            navigator.pushViewController(destinationVC, animated: true)
        }
    }
}
