//
//  URLMatcher+Group.swift
//  Integrator
//
//  Created by Eduardo Bocato on 13/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import UIKit

extension URLMatcher {
    
    /**
     A group of URLMatchers, and some shortcuts to create groups.
     */
    public struct Group {
        
        /// URL matchers
        let matchers: [URLMatcher]
        
        /// Set a group of mapped paths for some hosts
        public static func group(_ hosts: [String],
                                 _ mapPathsClosure: MapPathsClosure) -> Group {
            return .init(matchers: [URLMatcher(hosts: hosts, mapPathsClosure)])
        }
        
        /// Set a group of mapped paths for a host
        public static func group(_ host: String,
                                 _ mapPathsClosure: MapPathsClosure) -> Group {
            return group([host], mapPathsClosure)
        }
        
        // MARK: - Methods
        
        /// Find  matching URL
        internal func findMatch(forURL url: URL) throws -> RouteType? {
            for urlMatcher in matchers {
                if let route = try urlMatcher.match(url: url) {
                    return route
                }
            }
            
            return nil
        }
        
    }
    
}
