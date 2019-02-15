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
    case tabBar(_ tab: Tab)
    
}
extension AppRoutes: RouteType {
    
    
    //
    // MARK: - RouteProvider
    //
    
    var transition: RouteTransition {
        switch self {
        case .login: return .set
        case .tabBar: return .set
        }
    }
    
    static func registerURLs() -> URLMatcher.Group? {
        return URLMatcher.Group(matchers: [
            .group(["integrator.test.com", "localhost"]) {
                $0.map("login") { AppRoutes.login }
                $0.map("tabBar/{tab}") { try AppRoutes.tabBar(Tab(url: $0)) }
            }
        ])
    }
    
}
