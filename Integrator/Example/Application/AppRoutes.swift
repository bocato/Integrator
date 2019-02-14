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
    
//    static func registerURLs() -> URLMatcher.Group? {
//        return URLMatcher.Group(matchers: [
//            .group(["integrator.test.com", "localhost"]) {
//                $0.map("login") { self.login }
//                $0.map("homeTabBar/") { self.homeTabBar(nil) }
//                $0.map("homeTabBar/home/{text}") { try HomeTab.home($0.param("text")) }
//                $0.map("homeTabBar/profile") { HomeTab.profile }
//            }
//        ])
//    }
    
}
