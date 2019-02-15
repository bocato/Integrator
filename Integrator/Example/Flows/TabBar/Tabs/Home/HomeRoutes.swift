//
//  HomeRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 15/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

extension AppRoutes.Tab {
    
    enum Home: RouteType {
        
        // MARK: - Routes
        
        // Root controller of the home tab
        case root
        
        // MARK: - Initialization
        
        init(url: MatchedURL) throws {
            let path: String = try url.param("path")
            switch path {
            case "root":
                self = .root
            default: throw RouterError.couldNotFindRouteForMatchedURL(url)
            }
        }
        
        // MARK: - RouteProvider
        
        var transition: RouteTransition {
            switch self {
            case .root: return .set // it is a tab, set it
            }
        }
        
        static func registerURLs() -> URLMatcher.Group? {
            return URLMatcher.Group(matchers: [
                .group("") {
                    $0.map("root") { AppRoutes.Tab.Home.root }
                }
            ])
        }
        
    }
}
