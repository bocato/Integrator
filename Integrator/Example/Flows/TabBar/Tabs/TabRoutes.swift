////
////  TabRoutes.swift
////  Integrator
////
////  Created by Eduardo Bocato on 18/02/19.
////  Copyright © 2019 Eduardo Bocato. All rights reserved.
////
//
//import UIKit
//
//extension AppRoutes {
//    
//    enum Tab: RouteType {
//        
////        // MARK: - Initialization
////
////        init(url: MatchedURL) throws {
////            let tabName: String = try url.param("tab")
////            switch tabName {
////            case "home":
////                let homePath = try Home(url: url)
////                self = .home(homePath)
////            case "profile":
////                let profilePath = try Profile(url: url)
////                self = .profile(profilePath)
////            default: throw RouterError.couldNotFindRouteForMatchedURL(url)
////            }
////        }
////
//        // MARK: - Routes
//        
//        /// Root tab
//        case home(Home)
//        
//        /// presented home TabBarcontroller
//        case profile(Profile)
//        
//        // MARK: - RouteProvider
//        
//        var transition: RouteTransition {
//            switch self {
//            case .home, .profile: return .set // these are tabs, so, set them
//            }
//        }
//        
//    }
//    
//}
