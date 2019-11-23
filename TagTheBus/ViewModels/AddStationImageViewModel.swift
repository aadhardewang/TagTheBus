//
//  AddStationImageViewModel.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class AddStationImageViewModel: NSObject {
    var stationImageDetail: StationImageDetailModel?
    
    func updateStationDetails(_ stationId: Int, image: UIImage) {
        stationImageDetail = StationImageDetailModel(with: image, stationId: stationId)
    }
    
    func updateTitle(_ title: String) {
        stationImageDetail?.title = title
    }
    
    func saveImageDaata() -> Bool {
        stationImageDetail?.date = Date()
        if stationImageDetail != nil, let id = DatabaseManager.shared.insertImageDetail(with: stationImageDetail!) {
            stationImageDetail?.id = id
            return true
        }
        return false
    }
    
    func isValidImageData() -> String? {
        if (stationImageDetail?.title ?? "").trimmed.count == 0 {
            return "Please enter title."
        }
        return nil
    }
}
