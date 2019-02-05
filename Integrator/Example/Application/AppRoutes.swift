//
//  AppRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

enum AppRoutes: RouteProvider {
    
    // MARK: - Routes
    
    /// Root view controller
    case login(delegate: LoginViewControllerDelegate)
    
    /// presented home tabbarcontroller
    case home
    
    // forgot password
    case forgotPassword
    
    // MARK: - RouteProvider
    
    var transition: RouteTransition {
        switch self {
        case .login: return .set
//        case .home: return .push
        default: return .push
        }
    }
    
    /// Prepare the route for transition and return the view controller
    ///  to transition to on the view hierachy
    func prepareForTransition(from viewController: UIViewController) throws -> UIViewController {
        switch self {
        case .login(let delegate):
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            loginViewController.delegate = delegate
            return loginViewController
        case .home: return HomeViewController.initFromNib()
        case .forgotPassword: return ProfileViewController.initFromNib()
        }
    }
    
    
}
