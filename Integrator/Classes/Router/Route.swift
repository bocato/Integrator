//
//  Route.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

public protocol Route { // ENUM
    
    /// Route name
    var name: String { get }
    
    /// Transition type
    var transition: RouteTransition { get }
    
    // MARK: - Methods
    
    ///
    /// Prepare the route for transition and return the view controller
    ///  to transition to on the view hierachy.
    ///
    /// - Note: Throwing an error here will cancel the transition
    ///
    func prepareForTransition<T: UIViewController>(from viewController: UIViewController) throws -> T
    
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
    func registerURLs() -> URLMatcher.Group?
    
}

public extension Route {
    
    /// Route name, `login(username: String, password: String)` will become `login`
    public var name: String {
        return String(describing: self).components(separatedBy: "(").first ?? "RouteName"
    }
    
    /// Register URLs default
    func registerURLs() -> URLMatcher.Group? {
        return nil
    }
    
}
