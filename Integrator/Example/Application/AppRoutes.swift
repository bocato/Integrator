//
//  AppRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

enum AppRoutes {
    
    //
    // MARK: - Routes
    //
    
    /// Root view controller
    case login
    
    /// presented home TabBarcontroller
    case homeTabBar(_ tab: HomeTab)
    
}
extension AppRoutes: RouteType {
    
    
    //
    // MARK: - RouteProvider
    //
    
    var transition: RouteTransition {
        switch self {
        case .login: return .set
        case .homeTabBar: return .set
        }
    }
    
    static func registerURLs() -> URLMatcher.Group? {
        return URLMatcher.Group(matchers: [
            .group(["integrator.test.com", "localhost"]) {
                $0.map("login") { AppRoutes.login }
                $0.map("homeTabBar/*") { try HomeTab(url: $0) }
            }
        ])
    }
    
}
