//
//  StationsPageViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class StationsPageViewController: UIPageViewController {

    var pages = [UIViewController]()
    var currentPage = StationPageType.list
    var pendingIndex = StationPageType.map
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    // MARK: - Custom Methods
    private func setScreenLayout() {
        let listPage = StationsListViewController.instance()
        pages.append(listPage)
        let mapPage = StationsMapViewController.instance()
        pages.append(mapPage)
        delegate = self
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    
    func setCurrentIndex(type: StationPageType) {
        if type.rawValue < pages.count {
            if type.rawValue < currentPage.rawValue {
                setViewControllers([pages[type.rawValue]], direction: .reverse, animated: true, completion: nil)
            } else {
                setViewControllers([pages[type.rawValue]], direction: .forward, animated: true, completion: nil)
            }
            currentPage = type
        }
    }
    
    func didTapOnNavigationButton() {
        if let stationsMapVC = pages.filter({ $0 is StationsMapViewController }).first as? StationsMapViewController {
            stationsMapVC.updateUserLocation()
        }
    }
}

extension StationsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let first = pendingViewControllers.first, let pendingIndex = pages.firstIndex(of: first), let type = StationPageType(rawValue: pendingIndex) else {
            return
        }
        self.pendingIndex =  type
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentPage = pendingIndex
        }
    }
}
