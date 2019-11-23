//
//  UIViewControllerExtension.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIViewController {
    static func instance(_ stoaryboard: Storyboards = .main, identifier: String? = nil) -> UIViewController {
        let storyboardInstance = UIStoryboard(name: stoaryboard.rawValue, bundle: Bundle.main)
        let vc = storyboardInstance.instantiateViewController(withIdentifier: identifier ?? self.nameOfClass)
        return vc
    }
    
    func displayAlert(with title: String?, message: String?, buttonTitles: [String], alertActionStyles: [UIAlertAction.Style]? = nil, alertAction: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let styles = alertActionStyles ?? []
        for i in 0 ..< buttonTitles.count {
            let style: UIAlertAction.Style = styles.indices.contains(i) ? styles[i] : .default
            let action = UIAlertAction(title: buttonTitles[i], style: style) { (_) in
                alertAction(buttonTitles[i])
            }
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func openCameraOrLibraryActionSheet(sender: UIView? = nil, completion: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    self.openCameraOrPhotoLibrary(isCamera: true, completion: completion)
                }
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Open Photo Library", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                self.openCameraOrPhotoLibrary(isCamera: false, completion: completion)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController, let sender = sender {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .down
        }
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func openCameraOrPhotoLibrary(isCamera: Bool, allowsEditing: Bool = true, completion: @escaping () -> Void) {
        if !checkImagePickerPermission(isCamera: isCamera, allowsEditing: allowsEditing, completion: completion) {
            return;
        }
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera), isCamera {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .savedPhotosAlbum
        }
        picker.delegate = self as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        picker.allowsEditing = allowsEditing
        present(picker, animated: true, completion: {
            completion()
        })
    }
    
    private func checkImagePickerPermission(isCamera: Bool, allowsEditing: Bool, completion: @escaping () -> Void) -> Bool {
        let permissionManager = PermissionManager()
        var message: String?
        if isCamera, permissionManager.cameraStatus == .denied {
            message = "TagTheBus needs to access Camera in order to take pictures. Please, go to settings and provide us the access."
        } else if !isCamera, permissionManager.photosStatus == .denied {
            message = "TagTheBus needs to access Photos in order to choose photos. Please, go to settings and provide us the access."
        } else if !isCamera, permissionManager.photosStatus == .notDetermined {
            permissionManager.askForPermission(of: .photos) { (status) in
                if status == .denied {
                    self.displayPermissionDeniedAlert(with: "TagTheBus needs to access Photos in order to choose photos. Please, go to settings and provide us the access.") { (openSettings) in
                        if openSettings {
                            Helper.opneAppSettings {  }
                        }
                    }
                } else if status == .authorized {
                    self.openCameraOrPhotoLibrary(isCamera: isCamera, allowsEditing: allowsEditing, completion: completion)
                }
            }
            return false;
        }
        if let message = message {
            displayPermissionDeniedAlert(with: message) { (openSettings) in
                if openSettings {
                    Helper.opneAppSettings {  }
                }
            }
        }
        return message == nil
    }
    
    func displayPermissionDeniedAlert(with message: String, completion: @escaping (Bool) -> Void) {
        displayAlert(with: "Permission Denied!", message: message, buttonTitles: ["Settings", "Cancel"], alertActionStyles: [.default, .cancel]) { (title) in
            completion(title == "Settings")
        }
    }
}
