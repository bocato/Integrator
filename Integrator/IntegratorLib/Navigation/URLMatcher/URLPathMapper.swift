//
//  URLPathMapper.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  NOTE: This is from XRouter
//

import Foundation

/**
 Router URL Path Mapper.
 
 - Note: All static paths are resolved before dynamic paths.
 
 Usage:
 ```
 // Static path
 $0.map("/users") { .allUsers }
 
 // Dynamic path
 $0.map("/users/{id}/profile") { try .profile(withID: $0.param("id")) }
 */
public class URLPathMapper<Route: RouteType> {
    
    //
    // MARK: - Typealiases
    //
    
    /// Mapping for a dynamic path
    internal typealias DynamicPathMapping = ((MatchedURL) throws -> Route)
    
    /// Mapping for a static path
    internal typealias StaticPathMapping = (() throws -> Route)
    
    //
    // MARK: - Properties
    //
    
    /// Dynamic path patterns
    private var dynamicPathPatterns = [PathPattern: ((MatchedURL) throws -> Route)]()
    
    /// Simple path patterns
    private var staticPathPatterns = [PathPattern: (() throws -> Route)]()
    
    //
    // MARK: - Methods
    //
    
    /// Map a path to a route
    /// - Note: With the `MatchedURL` passed as a parameter in the callback
    public func map(_ pathPattern: PathPattern, _ route: @escaping (MatchedURL) throws -> Route) {
        dynamicPathPatterns[pathPattern] = route
    }
    
    /// Map a path to a route
    public func map(_ pathPattern: PathPattern, _ route: @escaping () throws -> Route) {
        staticPathPatterns[pathPattern] = route
    }
    
    /// Match a Route from a URL
    internal func match(_ url: URL) throws -> Route? {
        
        // Check for matches on all static paths
        for (pattern, route) in staticPathPatterns {
            if match(pattern, url) != nil {
                return try route()
            }
        }
        
        // Check for matches on all dynamic paths
        for (pattern, route) in dynamicPathPatterns {
            if let matchedLink = match(pattern, url) {
                return try route(matchedLink)
            }
        }
        
        return nil
    }
    
    /// Compare a pattern to a URL
    /// - Returns: A matched routable link
    private func match(_ pattern: PathPattern, _ url: URL) -> MatchedURL? {
        let pathComponents = url.pathComponents.compactMap { $0 == "/" ? nil : $0 }
        var parameters = [String: String]()
        
        for (index, patternComponent) in pattern.components.enumerated() {
            guard let pathComponent = pathComponents[safe: index],
                patternComponent.matches(pathComponent) else {
                    return nil
            }
            
            // Store the parameters
            if case let .parameter(name) = patternComponent {
                parameters[name] = pathComponent
            }
        }
        
        return MatchedURL(for: url, namedParameters: parameters)
    }
    
}
