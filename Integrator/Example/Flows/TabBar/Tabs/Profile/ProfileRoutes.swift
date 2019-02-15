//
//  ProfileRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 15/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

extension AppRoutes.Tab {
    
    enum Profile: RouteType {
        
        // MARK: - Routes
        
        // Root controller of the profile tab
        case root
        
        /// the details of the profile
        case details(Detail)
        
        // MARK: - Initialization
        
        init(url: MatchedURL) throws {
            let path: String = try url.param("path")
            switch path {
            case "root":
                self = .root
            case "details":
                self = .details(.root)
            default: throw RouterError.couldNotFindRouteForMatchedURL(url)
            }
        }
        
        // MARK: - RouteProvider
        
        var transition: RouteTransition {
            switch self {
            case .root: return .set
            case .details: return .push
            }
        }
        
        static func registerURLs() -> URLMatcher.Group? {
            return URLMatcher.Group(matchers: [
                .group("") {
                    $0.map("root") { Profile.root }
                    $0.map("details/{path}") { try Profile.details( Detail(url: $0) ) }
                }
            ])
        }
        
        enum Detail: RouteType {
            
            // MARK: - Routes
            
            // Root controller of the profile tab
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
                case .root: return .push
                }
            }
            
            static func registerURLs() -> URLMatcher.Group? {
                return URLMatcher.Group(matchers: [
                    .group("") {
                        $0.map("root") { Detail.root }
                    }
                    ])
            }
            
        }
        
    }
    
}
