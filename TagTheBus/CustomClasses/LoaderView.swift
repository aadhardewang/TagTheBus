//
//  LoaderView.swift
//  TagTheBus
//
//  Created by Aadhar on 24/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var activityContainerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let animationTime: TimeInterval = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    //MARK: - Public Functions
    
    static func show() {
        if let visibleWindow = UIWindow.visibleWindow(), getLoaderViewIfPreviouslyPresent() == nil {
            let loaderView = LoaderView(frame: UIScreen.main.bounds)
            loaderView.activityIndicator.startAnimating()
            visibleWindow.addSubview(loaderView)
            loaderView.activityContainerView.transform = CGAffineTransform.identity.scaledBy(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
            UIView.animate(withDuration: animationTime) {
                loaderView.activityContainerView.transform = CGAffineTransform.identity
            }
        }
    }
    
    static func hide() {
        if let loaderView = getLoaderViewIfPreviouslyPresent() {
            UIView.animate(withDuration: animationTime, animations: {
                loaderView.activityContainerView.transform = CGAffineTransform.identity.scaledBy(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude)
            }) { (_) in
                loaderView.remove()
            }
        }
    }
    
    //MARK: - Private Functions
    
    private func initialSetup() {
        _ = Bundle.main.loadNibNamed(nameOfClass, owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
    }
    
    private func remove() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
    
    private static func getLoaderViewIfPreviouslyPresent() -> LoaderView? {
        var toastView: LoaderView? = nil
        if let visibleWindow = UIWindow.visibleWindow() {
            for subView in visibleWindow.subviews {
                if let ddView = subView as? LoaderView {
                    toastView = ddView
                    break;
                }
            }
        }
        return toastView
    }
    
}
