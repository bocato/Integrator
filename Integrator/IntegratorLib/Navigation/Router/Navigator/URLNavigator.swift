//
//  URLNavigator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

internal class URLNavigator<Route: RouteType> {
    
    // MARK: - Properties
    
    /// Navigator to "translate" the url's to routes, it is the one the knows the Routes for the app
    private let navigator: Navigator<Route>
    
    /// A path mapper to translate the pathPatterns to routes
    private let pathMapper: URLPathMapper<Route>
    
    // MARK: - Intialiser
    
    /// Initialises the URLNavigator
    ///
    /// - Parameter navigator: a navigator to "translate" the url's to routes
    init(navigator: Navigator<Route>) {
        self.navigator = navigator
        self.pathMapper = URLPathMapper<Route>()
    }
    
    // MARK: - URL Routing
    
    /// Registers a url pattern in order to match with a RouteType
    ///
    /// - Parameters:
    ///   - urlPattern: an URL pattern to match against a RouteType
    ///   - route: a routeType to match against an URL pattern
    func associatePathPattern(_ pathPattern: PathPattern, toRouteResolver resolver: @escaping (MatchedURL) throws -> Route) {
        pathMapper.map(pathPattern, resolver)
    }
    
    // MARK: - URL Parsing
    
    ///
    /// Find a matching Route for a URL.
    ///
    /// - Note: This method throws an error when the route is mapped
    ///         but the mapping fails.
    ///
    private func findMatchingRoute(for url: URL) throws -> Route? {
        if let route = try pathMapper.match(url) {
            return route
        }
        return nil
    }
    
    // MARK: - Navigation
    
    /// Navigate using URLs
    ///
    /// - Parameters:
    ///   - url: And URL that can be parsed to a pre-define route
    ///   - rootViewController: the root controller to start the flow from
    ///   - animated: true or false, as the systems default
    ///   - presentationCompletion: callback to identify if the navigation was successfull, after presentation
    ///   - dismissalCompletion: callback when the viewController is being dismissed
    @discardableResult
    func openURL(_ url: URL,
                 from rootViewController: UIViewController? = nil,
                 customTransitionDelegate: RouterCustomTransitionDelegate?,
                 animated: Bool = true,
                 presentationCompletion: ((Error?) -> Void)? = nil,
                 dismissingCompletion: ((UIViewController?) -> Void)? = nil) -> Bool {
        do {
            guard let route = try findMatchingRoute(for: url) else {
                presentationCompletion?(nil) // No matching route
                return false
            }
            navigator.navigate(to: route,
                               rootViewController: rootViewController,
                               customTransitionDelegate: customTransitionDelegate,
                               animated: animated,
                               presentationCompletion: presentationCompletion,
                               dismissingCompletion: dismissingCompletion)
            return true
        } catch {
            presentationCompletion?(error) // error finding the route
        }
        return false
    }
    
}
