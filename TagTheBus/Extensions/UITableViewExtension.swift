//
//  UITableViewExtension.swift
//  TagTheBus
//
//  Created by Aadhar on 24/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

extension UITableView {
    func displayBackground(text: String, font: UIFont = UIFont.systemFont(ofSize: 16.0)) {
        let label = UILabel()
        if let headerView = tableHeaderView {
            label.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: bounds.size.width, height: bounds.size.height - headerView.bounds.size.height)
        } else {
            label.frame = CGRect(x: 10, y: 0, width: bounds.size.width - 20, height: bounds.size.height)
        }
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = font
        let view = UIView(frame: bounds)
        view.addSubview(label)
        backgroundView = view
    }
    
    func removeBackgroundText() {
        backgroundView = nil
    }
}
