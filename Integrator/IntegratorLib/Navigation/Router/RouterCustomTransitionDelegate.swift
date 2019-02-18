//
//  RouterCustomTransitionDelegateProtocol.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  NOTE: This is from XRouter
//

import UIKit

/**
 Delegate methods that can be used to configure custom transitions in `XRouter.Router`.
 */
public protocol RouterCustomTransitionDelegate: class {
    
    //
    // MARK: - Delegate methods
    //
    
    /// Perform a custom transition
    func performTransition(to viewController: UIViewController,
                           from sourceViewController: UIViewController,
                           transition: RouteTransition,
                           animated: Bool,
                           completion: ((Error?) -> Void)?)
    
}
