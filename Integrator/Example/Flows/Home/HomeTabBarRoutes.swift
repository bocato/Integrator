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
            let tabName = try url.param("tab")
            switch tabName {
            case "home":
                let text = try url.param("text")
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
        
    }
    
}


