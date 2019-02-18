//
//  UINavigationControllerExtensions.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  NOTE: This is from XRouter
//

import UIKit

/**
 Variants of push/set navigation with a completion closure
 Source: https://stackoverflow.com/a/33767837
 Author: https://stackoverflow.com/users/312594/par
 */
extension UINavigationController {
    
    /// Push view controllers with completion closure
    internal func pushViewController(_ viewController: UIViewController,
                                     animated: Bool,
                                     completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            completion()
        }
    }
    
    /// Set view controllers with completion closure
    internal func setViewControllers(_ viewControllers: [UIViewController],
                                     animated: Bool,
                                     completion: @escaping () -> Void) {
        setViewControllers(viewControllers, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in
            completion()
        }
    }
    
}
