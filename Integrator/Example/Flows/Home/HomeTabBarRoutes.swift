//
//  HomeTabBarRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

enum HomeTabBarRoutes: CaseIterable {
    
    //
    // MARK: - Routes
    //
    
    /// Root tab
    case home
    
    /// presented home TabBarcontroller
    case profile
    
}
extension HomeTabBarRoutes: RouteProvider {
    
    //
    // MARK: - RouteProvider
    //
    
    var transition: RouteTransition {
        switch self {
        case .home: return .set
        case .profile: return .set
        }
    }
    
    static func registerURLs() -> URLMatcher.Group? {
        return URLMatcher.Group(matchers: [
            .group(["integrator.test.com", "localhost"]) {
                $0.map("home") { HomeTabBarRoutes.home }
                $0.map("profile") { HomeTabBarRoutes.profile }
            }
        ])
    }
    
}
