//
//  StringExtension.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
