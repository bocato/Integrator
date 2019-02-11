//
//  AppRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

enum AppRoutes: CaseIterable {
    
    //
    // MARK: - Routes
    //
    
    /// Root view controller
    case login
    
    /// presented home TabBarcontroller
    case homeTabBar
    
}
extension AppRoutes: RouteProvider {
    
    //
    // MARK: - RouteProvider
    //
    
    var transition: RouteTransition {
        switch self {
        case .login: return .set
        case .homeTabBar: return .push
        }
    }
    
    static func registerURLs() -> URLMatcher.Group? {
        return URLMatcher.Group(matchers: [
            .group(["integrator.test.com", "localhost"]) {
                $0.map("login") { AppRoutes.login }
                $0.map("home") { AppRoutes.homeTabBar }
            }
        ])
    }
    
}
