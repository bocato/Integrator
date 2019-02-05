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
    case login
    
    /// presented home tabbarcontroller
    case home
    
    // forgot password
    case forgotPassword
    
    // MARK: - RouteProvider
    
    var transition: RouteTransition {
        switch self {
        case .login: return .set
        case .home: return .push
        default: return .push
        }
    }
    static func registerURLs() -> URLMatcher.Group? {
        return nil // TODO: Implement
    }
    
    
}
