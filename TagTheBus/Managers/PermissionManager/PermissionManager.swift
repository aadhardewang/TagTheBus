//
//  PermissionManager.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PermissionManager: NSObject {

    var cameraStatus: PermissionStatus {
        return cameraPermissionStatus()
    }
    
    var photosStatus: PermissionStatus{
        return photosPermissionStatus()
    }
    
    var microphoneStatus: PermissionStatus {
        return microphonePermissionStatus()
    }
    
    //MARK: - Public Methods
    
    func askForPermission(of type: PermissionType, completion: @escaping (PermissionStatus) -> Void) {
        switch type {
        case .camera:
            askForCameraPermission(completion)
        case .photos:
            askForPhotosPermission(completion)
        case .microphone:
            askForMicrophonePermission(completion)
        }
    }
    
    //MARK: - Permission Status
    
    private func cameraPermissionStatus() -> PermissionStatus {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined:
                return .notDetermined
            case .restricted, .denied:
                return .denied
            case .authorized:
                return .authorized
            default:
                return .denied
            }
        } else {
            return .denied
        }
    }
    
    private func photosPermissionStatus() -> PermissionStatus {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            return .notDetermined
        case .restricted, .denied:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }
    
    private func microphonePermissionStatus() -> PermissionStatus {
        let audioSession = AVAudioSession.sharedInstance()
        let status = audioSession.recordPermission
        switch status {
        case .undetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .granted:
            return .authorized
        default:
            return .denied
        }
    }
    
    //MARK: - Ask Permission
    
    private func askForCameraPermission(_ completion: @escaping (PermissionStatus) -> Void) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                completion(granted ? .authorized : .denied)
            }
        } else {
            completion(.denied)
        }
    }
    
    private func askForPhotosPermission(_ completion: @escaping (PermissionStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .notDetermined:
                completion(.notDetermined)
            case .restricted, .denied:
                completion(.denied)
            case .authorized:
                completion(.authorized)
            default:
                completion(.denied)
            }
        }
    }
    
    private func askForMicrophonePermission(_ completion: @escaping (PermissionStatus) -> Void) {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (granted) in
            completion(granted ? .authorized : .denied)
        }
    }

}

enum PermissionStatus {
    case notDetermined
    case denied
    case authorized
}

enum PermissionType {
    case camera
    case microphone
    case photos
}

