//
//  MatchedURL.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import Foundation

/**
 A URL that has been matched to a registered `RouteProvider` route.
 
 Used for shortcuts when mapping registered URLs routes.
 
 - Note: For use when handling routing parameters.
 - See: `RouteProvider.registerURLs(...)` // TODO: Change this documentation
 */
public class MatchedURL {
    
    /// Associated URL
    public let rawURL: URL
    
    /// Query string parameter shortcuts
    private lazy var queryItems: [String: String] = {
        var queryItems = [String: String]()
        URLComponents(url: rawURL, resolvingAgainstBaseURL: false)?
            .queryItems?
            .filter { $0.value != nil }
            .forEach { queryItems[$0.name] = $0.value }
        return queryItems
    }()
    
    /// Path parameters storage
    private let parameters: [String: String]
    
    // MARK: - Methods
    
    /// Initialiser
    init(for url: URL, namedParameters: [String: String]) {
        self.rawURL = url
        self.parameters = namedParameters
    }
    
    /// Retrieve a named parameter as a `String`
    public func param(_ name: String) throws -> String {
        guard let parameter = parameters[name] else {
            throw RouterError.missingRequiredParameterWhileUnwrappingURLRoute(parameter: name)
        }
        return parameter
    }
    
    /// Retrieve a named parameter as an `Int`
    public func param(_ name: String) throws -> Int {
        let stringParam: String = try param(name)
        guard let intParam = Int(stringParam) else {
            throw RouterError.requiredIntegerParameterWasNotAnInteger(parameter: name, stringValue: stringParam)
        }
        return intParam
    }
    
    /// Retrieve a query string parameter as a `String`
    public func query(_ name: String) -> String? {
        return queryItems[name]
    }
    
    /// Retrieve a query string parameter as an `Int`
    public func query(_ name: String) -> Int? {
        guard let queryItem = queryItems[name] else { return nil }
        return Int(queryItem)
    }
    
}
