//
//  ReachabilityManager.swift
//  TagTheBus
//
//  Created by Aadhar on 21/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import Foundation
import Reachability

public class ReachabilityManager: NSObject {

    public static let shared = ReachabilityManager()
    private var internetReachability = try? Reachability()
    private var isNetworkAvailable: Bool = false
    public static var isNetworkRechable: Bool {
        return shared.isNetworkAvailable
    }
    
    override init() {
        super.init()
        if let reachability = internetReachability {
            isNetworkAvailable = reachability.connection != .unavailable
        }
    }
    
    // MARK: - Public Methods
    public func startReachabilityNotifier() {
        if let reachability = internetReachability {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChangedObserver, object: reachability)
            do {
                try reachability.startNotifier()
            } catch let error {
                print("reachability error -> \(error.localizedDescription)")
            }
        }
    }
    
    public func stopReachabilityNotifier() {
        if let reachability = internetReachability {
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChangedObserver, object: reachability)
        }
    }
    
    // MARK: - Public Methods
    @objc
    private func reachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
            case .wifi:
                isNetworkAvailable = true
            case .cellular:
                isNetworkAvailable = true
            case .unavailable, .none:
                isNetworkAvailable = false
            }
        }
    }
    
}

extension NSNotification.Name {
    static let reachabilityChangedObserver = NSNotification.Name("reachabilityChanged")
}
