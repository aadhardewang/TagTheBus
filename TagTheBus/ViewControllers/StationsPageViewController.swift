//
//  StationsPageViewController.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

protocol StationsPageViewControllerProtocol: NSObjectProtocol {
    func updateSelectedSegment(pageIndex: Int)
}

class StationsPageViewController: UIPageViewController {

    /// Properties
    var pages = [UIViewController]()
    var currentPage = StationPageType.list
    var pendingIndex = StationPageType.map
    weak var delegateStations: StationsPageViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScreenLayout()
    }
    
    // MARK: - Custom Methods
    func setScreenLayout() {
        let listPage = storyboard?.instantiateViewController(withIdentifier: kStationsListViewController) as! StationsListViewController
        pages.append(listPage)
        let mapPage = storyboard?.instantiateViewController(withIdentifier: kStationsMapViewController) as! StationsMapViewController
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
            delegateStations?.updateSelectedSegment(pageIndex: currentPage.rawValue)
        }
    }
}
