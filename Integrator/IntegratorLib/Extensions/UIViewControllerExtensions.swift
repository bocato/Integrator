//
//  UIViewControllerExtensions.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  NOTE: This is from XRouter
//

import UIKit
import Foundation

/**
 UIViewController extension
 */
internal extension UIViewController {
    
    // MARK: - Methods
    
    /// If this is a container view controller, get child and it is visible
    /// - Note: Currently does not handle split view controller
    internal var visibleViewController: UIViewController {
        return presentedViewController
            ?? (self as? UITabBarController)?.selectedViewController
            ?? (self as? UINavigationController)?.visibleViewController
            ?? self
    }
    
    /// Dismiss then transition to descendant view controller.
    internal func transition(toDescendant viewController: UIViewController,
                             animated: Bool,
                             completion: @escaping () -> Void) {
        dismissIfNeeded(animated: animated) {
            // Switch tabs if this is a tab bar controller
            if let tabBarController = self as? UITabBarController {
                tabBarController.switchToTabIfNeeded(for: viewController)
            }
            
            completion()
        }
    }
    
    ///
    /// Get the lowest common ancestor between this and another view controller.
    ///
    /// - Returns: Lowest common ancestor, or `nil` if there is no common ancestor.
    ///
    internal func getLowestCommonAncestor(with viewController: UIViewController) -> UIViewController? {
        var currentABranch = self
        var currentBBranch = viewController
        
        var aBranch: [UIViewController] = [currentABranch]
        var bBranch: [UIViewController] = [currentBBranch]
        
        while let directParent = currentABranch.directParentViewController {
            currentABranch = directParent
            aBranch.append(directParent)
        }
        
        while let directParent = currentBBranch.directParentViewController {
            currentBBranch = directParent
            bBranch.append(directParent)
        }
        
        for aViewController in aBranch {
            for bViewController in bBranch {
                if aViewController === bViewController {
                    return aViewController
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Implementation
    
    ///
    /// Direct parent view controller
    ///
    /// In order, this goes: Navigation, SplitView, TabBar, Presenting
    ///
    private var directParentViewController: UIViewController? {
        return navigationController
            ?? splitViewController
            ?? tabBarController
            ?? presentingViewController
    }
    
    /// Dismiss modals. Always fires the completion handler.
    private func dismissIfNeeded(animated: Bool, completion: @escaping () -> Void) {
        if presentedViewController == nil {
            completion()
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }
    
    /// Fetch the top-most view controller
    /// - Source: https://stackoverflow.com/a/50656239
    static internal func getTopViewController(for baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = baseViewController as? UINavigationController, navigationController.viewControllers.count > 0 {
            return getTopViewController(for: navigationController.visibleViewController)
        }
        
        if let tabBarViewController = baseViewController as? UITabBarController,
            let selectedViewController = tabBarViewController.selectedViewController {
            return getTopViewController(for: selectedViewController)
        }
        
        if let presented = baseViewController?.presentedViewController {
            return getTopViewController(for: presented)
        }
        
        return baseViewController
    }
    
    /// Returns a new ViewController of the required type
    //  - Note: Use the same name on the Xib
    class func initFromNib<T: UIViewController>() -> T {
        return UIViewController(nibName: String(describing: self), bundle: Bundle(for: self)) as! T
    }
    
}
