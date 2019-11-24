//
//  UIViewExtension.swift
//  TagTheBus
//
//  Created by Aadhar on 24/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            if let borderColor = self.layer.borderColor {
                return UIColor(cgColor: borderColor)
            }
            return UIColor()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
}
