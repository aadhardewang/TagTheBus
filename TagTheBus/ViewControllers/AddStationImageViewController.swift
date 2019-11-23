//
//  AddStationImageViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

protocol AddStationImageProtocol: NSObjectProtocol {
    func didAddImageDetail(_ stationImageDetail: StationImageDetailModel)
}

class AddStationImageViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    var saveButton: UIBarButtonItem!
    private let addStationImageViewModel = AddStationImageViewModel()
    weak var delegate: AddStationImageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    // MARK: - Custom Methods
    private func setScreenLayout() {
        stationImageView.image = addStationImageViewModel.stationImageDetail?.image
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTap(_:)))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    func updateStationDetails(_ stationId: Int, image: UIImage) {
        addStationImageViewModel.updateStationDetails(stationId, image: image)
    }
    
    @objc private func saveButtonTap(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        // Validation code here
        if let message = addStationImageViewModel.isValidImageData() {
            displayAlert(with: "Invalid Data", message: message, buttonTitles: ["Ok"]) { (_) in
            }
        } else {
            if addStationImageViewModel.saveImageDaata(), let stationDetail = addStationImageViewModel.stationImageDetail {
                delegate?.didAddImageDetail(stationDetail)
                navigationController?.popViewController(animated: true)
            }
        }
    }

}

extension AddStationImageViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        addStationImageViewModel.updateTitle(textField.text ?? "")
    }
}
