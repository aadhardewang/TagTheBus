//
//  UIWindowExtension.swift
//  TagTheBus
//
//  Created by Aadhar on 24/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

extension UIWindow {
    static func visibleWindow() -> UIWindow? {
        var currentWindow = UIApplication.shared.keyWindow
        if currentWindow == nil {
            let frontToBackWindows = Array(UIApplication.shared.windows.reversed())
            for window in frontToBackWindows {
                if window.windowLevel == UIWindow.Level.normal {
                    currentWindow = window
                    break
                }
            }
        }
        return currentWindow
    }
}
