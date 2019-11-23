//
//  Constants.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Annotation Identifier
let kAnnotation = "Annotation"

struct Helper {
    static func opneAppSettings(completionHandler: @escaping () -> Void) {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (_) in
                completionHandler()
            })
        }
    }
}
