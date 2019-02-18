//
//  MatchedURL.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  NOTE: This is from XRouter
//

import Foundation

/**
 A URL that has been matched to a registered `RouteType` route.
 
 Used for shortcuts when mapping registered URLs routes.
 
 - Note: For use when handling routing parameters.
 - See: `RouteType.registerURLs(...)`
 
 Usage:
 ```swift
 // Path parameters
 let str: String = try $0.param("myParam")
 let int: Int = try $0.param("id")
 
 // Query string parameters
 let str: String? = $0.query("myParam")
 let int: Int? = $0.query("myParam")
 ```
 */
public class MatchedURL {
    
    //
    // MARK: - Properties
    //
    
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
    
    //
    // MARK: - Initialization
    //
    
    /// Initialiser
    init(for url: URL, namedParameters: [String: String]) {
        self.rawURL = url
        self.parameters = namedParameters
    }
    
    //
    // MARK: - Methods
    //
    
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
