//
//  HomeTabBarRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

extension AppRoutes {
    
    enum HomeTab: RouteType {
        
        //
        // MARK: - Initialization
        //
        
        init(url: MatchedURL) throws {
            let tabName: String = try url.param("tab")
            switch tabName {
            case "home":
                guard let text: String = url.query("text") else {
                    throw RouterError.couldNotFindRouteForMatchedURL(url)
                }
                self = .home(text: text)
            case "profile":
                self = .profile
            default: throw RouterError.couldNotFindRouteForMatchedURL(url)
            }
        }
        
        //
        // MARK: - Routes
        //
        
        /// Root tab
        case home(text: String)
        
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
        
        static func registerURLs() -> URLMatcher.Group? {
            return URLMatcher.Group(matchers: [
                .group("") {
                    $0.map("profile") { AppRoutes.HomeTab.profile }
                    $0.map("home") { try HomeTab(url: $0) }
                }
            ])
        }
        
    }
    
}


