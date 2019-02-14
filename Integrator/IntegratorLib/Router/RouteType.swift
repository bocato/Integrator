//
//  RouteProvider.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import UIKit

public protocol RouteType { // Enum
    
    //
    // MARK: - Properties
    //
    
    /// Route name
    var name: String { get }
    
    /// Transition type
    var transition: RouteTransition { get }
    
    //
    // MARK: - Methods
    //
    
    ///
    /// Register a URL matcher group.
    ///
    /// Example:
    /// ```
    /// return .group(["website.com", "sales.website.com"]) {
    ///     $0.map("products") { .allProducts(page: $0.query("page") ?? 0) }
    ///     $0.map("products/{category}/") { try .productsShowcase(category: $0.param("category")) }
    ///     $0.map("user/*/logout") { .userLogout }
    /// }
    /// ```
    ///
    static func registerURLs() -> URLMatcher.Group?
    
}
extension RouteType {
    
    /// Route name, `login(username: String, password: String)` will become `login`
    public var name: String {
        return String(describing: self).components(separatedBy: "(")[0]
    }
    
    /// Transition type
    public var transition: RouteTransition {
        return .inferred
    }
    
    /// Register URLs default
    static func registerURLs() -> URLMatcher.Group? {
        return nil
    }
    
}
extension RouteType {
    
    // MARK: - Equatable
    
    /// Equatable (default: Compares on `name` property)
    public static func == (_ lhs: RouteType, _ rhs: RouteType) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
