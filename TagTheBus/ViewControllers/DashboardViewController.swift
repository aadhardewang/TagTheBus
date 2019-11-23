//
//  ViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var mapListSegmentedControl: UISegmentedControl!
    var navigationBarButton: UIBarButtonItem!
    
    /// Properties
    weak var stationsPageVC: StationsPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    // MARK: - Custom Methods
    func setScreenLayout() {
        navigationBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "location"), style: .plain, target: self, action: #selector(navigationBarButtonTap(_:)))
        navigationItem.setRightBarButtonItems([], animated: false)
    }
    
    func selectPage(index: Int) {
        navigationItem.setRightBarButtonItems(index == 0 ? [] : [navigationBarButton], animated: true)
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        stationsPageVC?.setCurrentIndex(type: StationPageType(rawValue: index) ?? .list)
    }
    
    // MARK: - Action Methods
    @IBAction func mapListSegmentValuChanged(_ sender: Any) {
        selectPage(index: mapListSegmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func navigationBarButtonTap(_ sender: UIBarButtonItem) {
        stationsPageVC?.didTapOnNavigationButton()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? StationsPageViewController {
            stationsPageVC = viewController
        }
    }
}

