//
//  CustomActivityItem.swift
//  TagTheBus
//
//  Created by Aadhar on 24/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class CustomActivityItem: NSObject, UIActivityItemSource {
    
    var title: String?
    var image: UIImage?
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        switch activityType! {
        case .mail, .postToTwitter, .postToFacebook:
            return title ?? image
        default:
            return nil
        }
    }

}

