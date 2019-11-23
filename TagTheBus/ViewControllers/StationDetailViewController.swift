//
//  StationDetailViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class StationDetailViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    
    /// Properties
    var navigationBarButton: UIBarButtonItem!
    let stationDetailViewModel = StationDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    func setStationDetail(_ stationDetails: StationsModel) {
        stationDetailViewModel.stationDetails = stationDetails
    }
    
    // MARK: - Custom Methods
    private func setScreenLayout() {
        navigationItem.title = stationDetailViewModel.stationDetails?.streetName
        navigationBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .plain, target: self, action: #selector(navigationBarButtonTap(_:)))
        navigationItem.setRightBarButtonItems([navigationBarButton], animated: false)
        stationDetailViewModel.getStationImageDetails()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func moveToAddImageView(_ image: UIImage) {
        if let destinationVC = AddStationImageViewController.instance() as? AddStationImageViewController, let stationDetails = stationDetailViewModel.stationDetails {
            destinationVC.updateStationDetails(stationDetails.id, image: image)
            destinationVC.delegate = self
            if let navigator = self.navigationController {
                navigator.pushViewController(destinationVC, animated: true)
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func navigationBarButtonTap(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.openCameraOrLibraryActionSheet(sender: self.view) {
            }
        }
    }
    
}

extension StationDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let pickedImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
                self.moveToAddImageView(pickedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension StationDetailViewController: AddStationImageProtocol {
    func didAddImageDetail(_ stationImageDetail: StationImageDetailModel) {
        stationDetailViewModel.addImageDetail(stationImageDetail)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension StationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationDetailViewModel.stationImageDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationDetailTableViewCell.nameOfClass) as! StationDetailTableViewCell
        let stationImageDetail = stationDetailViewModel.stationImageDetails[indexPath.row]
        cell.stationImageView.image = stationImageDetail.image
        cell.titleLabel.text = stationImageDetail.title
        cell.dateLabel.text = stationImageDetail.displayDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stationImageDetail = stationDetailViewModel.stationImageDetails[indexPath.row]
            if DatabaseManager.shared.deleteImageDetail(from: stationImageDetail.id, imageName: stationImageDetail.imageName) {
                stationDetailViewModel.stationImageDetails.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
}
