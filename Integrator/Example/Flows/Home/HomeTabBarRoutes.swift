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
      
        init?(name: String, params: [String: Any]?) throws {
            switch name {
            case "home":
                self = .home
            case "profile":
                self = .profile
            default: throw RouterError.couldNotFindRouteForPattern("/homeTab/\(name)")
            }
        }
        
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
        
    }
    
}


