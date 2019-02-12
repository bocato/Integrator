//
//  HomeTabBarRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

extension AppRoutes {
    
    enum HomeTabBar: RouteType & CaseIterable {
        
        //
        // MARK: - Routes
        //
        
        /// Root tab
        case home
        
        /// presented home TabBarcontroller
        case profile
        
        //
        // MARK: - RouteProvider
        //
        
        var transition: RouteTransition {
            switch self {
            case .home: return .set
            case .profile: return .set
            }
        }
        
        static func registerURLs() -> URLMatcher.Group? { // TODO: Check this...
            return URLMatcher.Group(matchers: [
                .group(["homeTabBar"]) {
                    $0.map("home") { self.home }
                    $0.map("profile") { self.profile }
                }
            ])
        }
        
    }
    
}


