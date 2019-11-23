//
//  StationImageDetailModel.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

struct StationImageDetailModel {
    var id: Int
    var image: UIImage?
    var imageName: String
    var title: String
    var date: Date
    var stationId: Int
    var displayDate: String
}

extension StationImageDetailModel {
    init(with image: UIImage, stationId: Int) {
        id = 0
        self.image = image
        imageName = ""
        title = ""
        date = Date()
        self.stationId = stationId
        displayDate = date.getString(with: .dateTime)
    }
    
    init(with dictionary: [String: Any]) {
        id = dictionary.getInt(forKey: DBConstants.StationsTableColumns.id.rawValue)
        imageName = dictionary.getString(forKey: DBConstants.StationsTableColumns.image.rawValue)
        image = DocumentsManager.loadImage(with: imageName)
        title = dictionary.getString(forKey: DBConstants.StationsTableColumns.title.rawValue)
        date = Date(timeIntervalSince1970: dictionary.getDouble(forKey: DBConstants.StationsTableColumns.createDateTime.rawValue))
        stationId = dictionary.getInt(forKey: DBConstants.StationsTableColumns.stationId.rawValue)
        displayDate = date.getString(with: .dateTime)
    }
}


