//
//  DateExtension.swift
//  TagTheBus
//
//  Created by Honey Maheshwari on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

extension Date {
    func getString(with format: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}
