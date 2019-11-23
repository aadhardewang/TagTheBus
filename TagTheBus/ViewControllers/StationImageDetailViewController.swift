//
//  StationImageDetailViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class StationImageDetailViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var stationImageView: UIImageView!
    
    /// Properties
    var navigationBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    //MARK: - Custom Methods
    func setScreenLayout() {
        navigationBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(navigationBarButtonTap(_:)))
        navigationBarButton.tintColor = .systemBlue
        navigationItem.setRightBarButtonItems([navigationBarButton], animated: false)
    }
    
    // MARK: - Action Methods
    @IBAction func navigationBarButtonTap(_ sender: UIBarButtonItem) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
