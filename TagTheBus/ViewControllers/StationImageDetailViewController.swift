//
//  StationImageDetailViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class StationImageDetailViewController: UIViewController {
    
    @IBOutlet weak var stationImageView: UIImageView!
    
    var navigationBarShareButton: UIBarButtonItem!
    let stationImageDetailViewModel = StationImageDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    //MARK: - Custom Methods
    private func setScreenLayout() {
        navigationItem.title = stationImageDetailViewModel.stationImageDetailModel?.title
        navigationBarShareButton = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(navigationBarButtonTap(_:)))
        navigationBarShareButton.tintColor = .systemBlue
        navigationItem.setRightBarButtonItems([navigationBarShareButton], animated: false)
        stationImageView.image = stationImageDetailViewModel.stationImageDetailModel?.image
    }
    
    func setStationImageDetail(_ stationImageDetailModel: StationImageDetailModel) {
        stationImageDetailViewModel.stationImageDetailModel = stationImageDetailModel
    }
    
    // MARK: - Action Methods
    @IBAction func navigationBarButtonTap(_ sender: UIBarButtonItem) {
        let str = CustomActivityItem()
        str.title = stationImageDetailViewModel.stationImageDetailModel?.title
        let image = CustomActivityItem()
        image.image = stationImageDetailViewModel.stationImageDetailModel?.image
        
        let activity = UIActivityViewController(activityItems: [str, image], applicationActivities: nil)
        activity.excludedActivityTypes = [.postToWeibo, .message, .print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .postToTencentWeibo, .airDrop, .openInIBooks, .markupAsPDF, UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
        UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"), UIActivity.ActivityType(rawValue: "com.apple.mobileslideshow.StreamShareService")]
        present(activity, animated: true, completion: nil)
    }

}
