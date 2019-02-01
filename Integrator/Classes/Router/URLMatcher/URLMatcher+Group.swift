//
//  URLMatcher+Group.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

public extension URLMatcher {
    
    /**
     A group of URLMatchers, and some shortcuts to create groups.
     */
    public struct Group {
        
        /// URL matchers
        let matchers: [URLMatcher]
        
        /// Set a group of mapped paths for some hosts
        public static func group(_ hosts: [String],
                                 _ mapPathsClosure: (URLPathMatcher) -> Void) -> URLMatcherGroup {
            return .init(matchers: [URLMatcher(hosts: hosts, mapPathsClosure)])
        }
        
        /// Set a group of mapped paths for a host
        public static func group(_ host: String,
                                 _ mapPathsClosure: (URLPathMatcher) -> Void) -> URLMatcherGroup {
            return group([host], mapPathsClosure)
        }
        
    }
    
}
