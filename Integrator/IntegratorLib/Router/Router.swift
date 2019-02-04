//
//  Router.swift
//  Integrator
//
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

public protocol RouterProtocol {
    
    //
    // MARK: - Properties
    //
    
    /// The viewController that starts the flow (could be anything that is )
    var rootViewController: UIViewController { get }
    
    /// Computed property to get the rootViewController as an UINavigationController, if possible
    var navigationController: UINavigationController? { get }
    
    /// Computed property to get the rootViewController as an UITabBarController, if possible
    var tabBarControllerr: UITabBarController? { get }
    
    /// The routes for this router
    var routes: RouteProvider { get }
    
    /// Custom transition delegate
    var customTransitionDelegate: RouterCustomTransitionDelegate? { get set }
    
    //
    // MARK: - Initialization
    //
    
    /// Initialise
    ///
    /// - Parameter rootViewController: the controller that marks the start of the flow
    ///   - route: the routes enum for this flow
    init(rootViewController: UIViewController, routes: RouteProvider)
    
    //
    // MARK: - Navigation Methods
    //
    
    /// Navigate using Enums
    ///
    /// - Parameters:
    ///   - route: an enum defining the possible routes
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    func navigate(to route: RouteProvider, animated: Bool, completion: ((Error?) -> Void)?)
    
    
    /// Navigate using URLs
    ///
    /// - Parameters:
    ///   - url: And URL that can be parsed to a pre-define route
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    @discardableResult
    func navigate(with url: URL, animated: Bool, completion: ((Error?) -> Void)?) -> Bool
}

public class Router: RouterProtocol {
    
    //
    // MARK: - Properties
    //
    
    /// The viewController that starts the flow (could be anything that is )
    public let rootViewController: UIViewController
    
    /// Returns the rootViewController as an UINavigationController, if possible
    public var navigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }
    
    /// Returns the rootViewController as an UITabBarController, if possible
    public var tabBarControllerr: UITabBarController? {
        return rootViewController as? UITabBarController
    }
    
    /// The pre-defined routes
    public let routes: RouteProvider
    
    /// Custom transition delegate
    public weak var customTransitionDelegate: RouterCustomTransitionDelegate?
    
    /// Register url matcher group
    private lazy var urlMatcherGroup: URLMatcher.Group? = routes.registerURLs()
    
    //
    // MARK: - Initialization
    //
    
    required public init(rootViewController: UIViewController, routes: RouteProvider) {
        self.rootViewController = rootViewController
        self.routes = routes
    }
 
    //
    // MARK: - Navigation Methods
    //
    
    /// Navigate, using the route enum
    ///
    /// - Note: Has no effect if the destination view controller is the view controller
    ///         or navigation controller you are presently on.
    ///
    open func navigate(to route: RouteProvider, animated: Bool = true, completion: ((Error?) -> Void)? = nil) {
        prepareForNavigation(to: route, animated: animated, successHandler: { (source, destination) in
            self.performNavigation(from: source,
                                   to: destination,
                                   with: route.transition,
                                   animated: animated,
                                   completion: completion)
        }, errorHandler: { error in
            completion?(error)
        })
    }
    
    /// Navigate matching an URL to a pre-defined route
    ///
    /// - Description: Open a URL to a route.
    ///
    /// - Note: Register your URL mappings in your `Route` by implementing the method `registerURLs`.
    ///         This should be used as input for the application, or from a module to another...
    ///         Avoid using it for all the internal navigation flow, try to use enums on this case.
    ///
    @discardableResult
    open func navigate(with url: URL, animated: Bool = true, completion: ((Error?) -> Void)?) -> Bool {
        do {
            guard let route = try findMatchingRoute(for: url) else {
                completion?(nil) // No matching route
                return false
            }
            navigate(to: route, animated: animated, completion: completion)
            return true
        } catch {
            completion?(error) // error finding the route
        }
        return false
    }
    
    //
    // MARK: - Implementation
    //
    
    ///
    /// Prepare the route for navigation.
    ///
    ///     - Fetching the view controller we want to present
    ///     - Checking if its already in the view heirarchy
    ///         - Checking if it is a direct ancestor and then closing its children/siblings
    ///
    /// - Note: The completion block will not execute if we could not find a route
    ///
    private func prepareForNavigation(to route: RouteProvider,
                                      animated: Bool,
                                      successHandler: @escaping (_ source: UIViewController, _ destination: UIViewController) -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
        
        guard let source = UIViewController.getTopViewController(for: rootViewController) else {
            errorHandler(RouterError.missingSourceViewController)
            return
        }
        
        let destination: UIViewController
        do {
            destination = try route.prepareForTransition(from: source)
        } catch {
            errorHandler(error)
            return
        }
        
        guard let nearestAncestor = source.getLowestCommonAncestor(with: destination) else {
            // No common ancestor - Adding destination to the stack for the first time
            successHandler(source, destination)
            return
        }
        
        // Clear modal - then prepare for child view controller.
        nearestAncestor.transition(toDescendant: destination, animated: animated) {
            successHandler(nearestAncestor.visibleViewController, destination)
        }

    }
    
    /// Perform navigation
    private func performNavigation(from source: UIViewController,
                                   to destination: UIViewController,
                                   with transition: RouteTransition,
                                   animated: Bool,
                                   completion: ((Error?) -> Void)?) {
        // Already here/on current navigation controller
        if destination === source || destination === source.navigationController {
            // No error? -- maybe throw an "already here" error
            completion?(nil)
            return
        }
        
        // The source view controller will be the navigation controller where
        //  possible - but will otherwise default to the current view controller
        //  i.e. for "present" transitions.
        let source = source.navigationController ?? source
        
        switch transition {
        case .push:
            guard let navigationControler = navigationController else {
                completion?(RouterError.missingRequiredNavigationController(for: transition))
                return
            }
            navigationControler.pushViewController(destination, animated: animated) {
                completion?(nil)
            }
        case .set:
            guard let navigationControler = navigationController else {
                completion?(RouterError.missingRequiredNavigationController(for: transition))
                return
            }
            navigationControler.setViewControllers([destination], animated: animated) {
                completion?(nil)
            }
        case .modal:
            source.present(destination, animated: animated) {
                completion?(nil)
            }
        case .custom:
            guard let customTransitionDelegate = customTransitionDelegate else {
                completion?(RouterError.missingCustomTransitionDelegate)
                return
            }
            customTransitionDelegate.performTransition(to: destination,
                                                       from: source,
                                                       transition: transition,
                                                       animated: animated,
                                                       completion: completion)
        }
    }
    
    //
    // MARK: - URL Parsing
    //
    
    ///
    /// Find a matching Route for a URL.
    ///
    /// - Note: This method throws an error when the route is mapped
    ///         but the mapping fails.
    ///
    private func findMatchingRoute(for url: URL) throws -> RouteProvider? {
        guard let urlMatcherGroup = urlMatcherGroup else { return nil }
        for urlMatcher in urlMatcherGroup.matchers {
            if let route = try urlMatcher.match(url: url) {
                return route
            }
        }
        return nil
    }
    
}
