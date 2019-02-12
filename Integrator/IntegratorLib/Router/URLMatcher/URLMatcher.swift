//
//  URLMatcher.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import Foundation

/**
 Represents a mapping of some set of path matchers for some hosts.
 */
public class URLMatcher {
    
    //
    // MARK: - Types
    //
    
    /// Closure to enable the path mapping
    public typealias MapPathsClosure = (URLPathMapper) -> Void
    
    //
    // MARK: - Properties
    //
    
    /// Only matches against these hosts
    internal let hosts: [String]
    
    /// Path mapper
    internal let pathMapper: URLPathMapper
    
    //
    // MARK: - Initialization
    //
    
    /// Init
    ///
    /// - Parameters:
    ///   - hosts: the hosts, ie, websites
    ///   - mapPathsClosure: closure to enable paths mapping
    internal init(hosts: [String], _ mapPathsClosure: MapPathsClosure) {
        self.hosts = hosts
        self.pathMapper = URLPathMapper()
        
        // Run the path matching
        mapPathsClosure(pathMapper)
    }
    
    //
    // MARK: - Methods
    //
    
    /// Set a group of mapped paths for some hosts
    public static func group(_ hosts: [String],
                             _ mapPathsClosure: MapPathsClosure) -> URLMatcher {
        return URLMatcher(hosts: hosts, mapPathsClosure)
    }
    
    /// Set a group of mapped paths for a host
    public static func group(_ host: String,
                             _ mapPathsClosure: MapPathsClosure) -> URLMatcher {
        return group([host], mapPathsClosure)
    }
    
    //
    // MARK: - Implementation
    //
    
    /// Match a URL to one of the paths, for any host.
    internal func match(url: URL) throws -> RouteType? {
        guard let host = url.host, hosts.contains(host) else {
            return nil
        }
        return try pathMapper.match(url)
    }
    
}



