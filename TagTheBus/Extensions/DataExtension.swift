//
//  DataExtension.swift
//  TagTheBus
//
//  Created by Aadhar on 22/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

extension Data {
    var dictionary: [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
