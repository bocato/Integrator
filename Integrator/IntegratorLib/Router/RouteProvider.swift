//
//  RouteProvider.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import UIKit

public protocol RouteProvider { // Enum, implementing CaseIterable
    
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

//    ///
//    /// Prepare the route for transition and return the view controller
//    ///  to transition to on the view hierachy.
//    ///
//    /// - Note: Throwing an error here will cancel the transition
//    ///
//    func prepareForTransition(from viewController: UIViewController) throws -> UIViewController
    
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

public extension RouteProvider {
    
    /// Route name, `login(username: String, password: String)` will become `login`
    public var name: String {
        return String(describing: self).components(separatedBy: "(")[0]
    }
    
    /// Register URLs default
    static func registerURLs() -> URLMatcher.Group? {
        return nil
    }
    
}
