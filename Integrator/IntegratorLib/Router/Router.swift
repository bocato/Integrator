//
//  RouterProtocol.swift
//  Integrator
//
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

public protocol RouterProtocol {
    
    //
    // MARK: - Types
    //
    
    /// A route resolver type
    typealias RouteResolverClosure = (_ route: RouteType) throws -> UIViewController
    
    //
    // MARK: - Properties
    //
    
    /// The navigationController that starts the flow
    var navigationController: UINavigationController { get }
    
    /// Custom transition delegate
    var customTransitionDelegate: RouterCustomTransitionDelegate? { get set }
    
    //
    // MARK: - Initialization
    //
    
    /// Initialization
    ///
    /// - Parameter rootViewController: the controller that marks the start of the flow
    ///   - navigationController: the navigationController that starts the route
    init(navigationController: UINavigationController)
    
    
    //
    // MARK: - Resolver functions
    //
    
    /// Register Resolvers for the routes in this flow
    ///
    /// - Parameters:
    ///   - route: The route you want to register a builder for the controller
    ///   - resolver: the delegate wich is going to resolve the route, i.e.,
    ///               configure it's controller before the transition
    func registerResolver<Route: RouteType>(forRouteType type: Route.Type, resolver: @escaping RouteResolverClosure)
    
    /// Gets a configuerd controller for a defined route, if the said route is configured
    ///
    /// - Parameter route: the route you want to resolve
    /// - Returns: a configuredViewControler for the expected route
    /// - Throws: and error if the resolver is not configured
    func resolveControllerForRoute(_ route: RouteType) throws -> UIViewController
    
    //
    // MARK: - Navigation Methods
    //
    
    /// Navigate using Enums
    ///
    /// - Parameters:
    ///   - route: an enum defining the possible routes
    ///   - rootViewController: a rootViewController to start the flow
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    func navigate(to route: RouteType,
                  rootViewController: UIViewController?,
                  animated: Bool,
                  completion: ((Error?) -> Void)?)
    
    /// Navigate using Enums
    ///
    /// - Parameters:
    ///   - route: an enum defining the possible routes
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    func navigate(to route: RouteType,
                  animated: Bool,
                  completion: ((Error?) -> Void)?)
    
    /// Navigate using URLs
    ///
    /// - Parameters:
    ///   - url: And URL that can be parsed to a pre-define route
    ///   - rootViewController: the root controller to start the flow from
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    @discardableResult
    func openURL(_ url: URL, from rootViewController: UIViewController?, animated: Bool, completion: ((Error?) -> Void)?) -> Bool
    
    /// Navigate using URLs
    ///
    /// - Parameters:
    ///   - url: And URL that can be parsed to a pre-define route
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    @discardableResult
    func openURL(_ url: URL, animated: Bool, completion: ((Error?) -> Void)?) -> Bool
}

public class Router<Route: RouteType>: RouterProtocol {
    
    //
    // MARK: - Properties
    //
    
    /// The navigationController that starts the flow
    public let navigationController: UINavigationController
    
    /// Custom transition delegate
    public weak var customTransitionDelegate: RouterCustomTransitionDelegate?
    
    /// Register url matcher group
    private lazy var urlMatcherGroup: URLMatcher.Group? = Route.registerURLs()
    
    /// Route resolver, where the key is `RouteType` implementation
    private var routeResolvers = [String: RouteResolverClosure]()
    
    //
    // MARK: - Initialization
    //
    
    required public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //
    // MARK: - Route Resolver functions
    //
    
    /// Register Resolvers for the routes in this flow
    ///
    /// - Parameters:
    ///   - route: The route you want to register a builder for the controller
    ///   - resolver: the delegate wich is going to resolve the route, i.e.,
    ///               configure it's controller before the transition
    public func registerResolver<Route>(forRouteType type: Route.Type, resolver: @escaping RouteResolverClosure) where Route : RouteType {
        let routeTypeName = String(describing: type)
        routeResolvers[routeTypeName] = resolver
    }
    
    /// Resolve the controller for the route
    ///
    /// - Parameter route: a route, conforming with the provider
    /// - Returns: the configured ViewController
    /// - Throws: an error telling us if the route could not be built
    private func findResolverForRoute(_ route: RouteType) throws -> RouteResolverClosure {
        let routeTypeName = String(describing: type(of: route))
        guard let resolver = routeResolvers[routeTypeName] else {
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        return resolver
    }
    
    /// Gets a configuerd controller for a defined route, if the said route is configured
    ///
    /// - Parameter route: the route you want to resolve
    /// - Returns: a configuredViewControler for the expected route
    /// - Throws: and error if the resolver is not configured
    public func resolveControllerForRoute(_ route: RouteType) throws -> UIViewController {
        
        let routeResolverClosure: RouteResolverClosure
        do {
            routeResolverClosure = try findResolverForRoute(route)
        } catch {
            throw error
        }
        
        let controler: UIViewController
        do {
            controler = try routeResolverClosure(route)
        } catch {
            throw error
        }
        
        return controler
        
    }
    
    //
    // MARK: - Navigation Methods
    //
    
    /// Navigate, using the route enum
    ///
    /// - Note: Has no effect if the destination view controller is the view controller
    ///         or navigation controller you are presently on.
    ///
    open func navigate(to route: RouteType,
                       rootViewController: UIViewController?,
                       animated: Bool,
                       completion: ((Error?) -> Void)?) {
        prepareForNavigation(to: route,
                             rootViewController: rootViewController ?? navigationController,
                             animated: animated,
                             successHandler: {  (source, destination) in
                                self.performNavigation(from: source,
                                                       to: destination,
                                                       with: route.transition,
                                                       animated: animated,
                                                       completion: completion)
        }, errorHandler: { error in
            completion?(error)
        })
    }
    
    /// Navigate, using the route enum
    ///
    /// - Note: Has no effect if the destination view controller is the view controller
    ///         or navigation controller you are presently on.
    ///
    open func navigate(to route: RouteType,
                      animated: Bool,
                      completion: ((Error?) -> Void)?) {
        navigate(to: route, rootViewController: nil, animated: animated, completion: completion)
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
    open func openURL(_ url: URL,
                      from rootViewController: UIViewController?,
                      animated: Bool = true,
                      completion: ((Error?) -> Void)?) -> Bool {
        do {
            guard let route = try findMatchingRoute(for: url) else {
                completion?(nil) // No matching route
                return false
            }
            navigate(to: route, rootViewController: nil, animated: animated, completion: completion)
            return true
        } catch {
            completion?(error) // error finding the route
        }
        return false
    }
    
    /// Navigate using URLs
    ///
    /// - Parameters:
    ///   - url: And URL that can be parsed to a pre-define route
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    @discardableResult
    open func openURL(_ url: URL, animated: Bool, completion: ((Error?) -> Void)?) -> Bool {
        return openURL(url, from: nil, animated: animated, completion: completion)
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
    private func prepareForNavigation(to route: RouteType,
                                      rootViewController: UIViewController?,
                                      animated: Bool,
                                      successHandler: @escaping (_ source: UIViewController, _ destination: UIViewController) -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
        
        guard let source = UIViewController.getTopViewController(for: rootViewController) else {
            errorHandler(RouterError.missingSourceViewController)
            return
        }
        
        let destination: UIViewController
        do {
            destination = try resolveControllerForRoute(route)
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
            pushTransition(source, destination, animated, completion)
        case .set:
            if source is UINavigationController {
                setTransition(source, destination, animated, completion)
            } else if source is UITabBarController {
                // TODO: check this...
                debugPrint("UITabBarController")
            }
        case .present:
            modalTransition(source, destination, animated, completion)
        case .inferred:
            if source is UITabBarController {
                // TODO: check this...
                debugPrint("UITabBarController")
            } else {
               inferTransition(source, destination, animated, completion)
            }
        case .custom:
            customTransition(transition, source, destination, animated, completion)
        }
    }
    
    // MARK: - Transitions
    
    /// Infer transition from context
    private func inferTransition(_ source: UIViewController,
                                 _ destination: UIViewController,
                                 _ animated: Bool,
                                 _ completion: ((Error?) -> Void)?) {
        if (source as? UINavigationController) == nil || (destination as? UINavigationController) != nil {
            modalTransition(source, destination, animated, completion)
        } else if destination.navigationController == source {
            setTransition(source, destination, animated, completion)
        } else {
            pushTransition(source, destination, animated, completion)
        }
    }
    
    /// Push transition
    private func pushTransition(_ source: UIViewController,
                                _ destination: UIViewController,
                                _ animated: Bool,
                                _ completion: ((Error?) -> Void)?) {
        guard let navController = source as? UINavigationController else {
            completion?(RouterError.missingRequiredNavigationController(for: .push))
            return
        }
        
        navController.pushViewController(destination, animated: animated) {
            completion?(nil)
        }
    }
    
    /// Set transition
    private func setTransition(_ source: UIViewController,
                               _ destination: UIViewController,
                               _ animated: Bool,
                               _ completion: ((Error?) -> Void)?) {
        guard let navController = source as? UINavigationController else {
            completion?(RouterError.missingRequiredNavigationController(for: .set))
            return
        }
        
        let viewControllers: [UIViewController]
        
        if let index = navController.viewControllers.firstIndex(of: destination) {
            //
            // Pop all view controllers above the destination
            //
            viewControllers = Array(navController.viewControllers[...index])
        } else {
            //
            // Set destination
            //
            viewControllers = [destination]
        }
        
        navController.setViewControllers(viewControllers, animated: animated) {
            completion?(nil)
        }
    }
    
    /// Modal transition
    private func modalTransition(_ source: UIViewController,
                                 _ destination: UIViewController,
                                 _ animated: Bool,
                                 _ completion: ((Error?) -> Void)?) {
        source.present(destination, animated: animated) {
            completion?(nil)
        }
    }
    
    /// Custom transition
    private func customTransition(_ transition: RouteTransition,
                                  _ source: UIViewController,
                                  _ destination: UIViewController,
                                  _ animated: Bool,
                                  _ completion: ((Error?) -> Void)?) {
        
        guard let delegate = customTransitionDelegate else {
            completion?(RouterError.missingCustomTransitionDelegate)
            return
        }
        
        delegate.performTransition(to: destination,
                                   from: source,
                                   transition: transition,
                                   animated: animated,
                                   completion: completion)
    }
    
    // MARK: - URL Parsing
    
    ///
    /// Find a matching Route for a URL.
    ///
    /// - Note: This method throws an error when the route is mapped
    ///         but the mapping fails.
    ///
    private func findMatchingRoute(for url: URL) throws -> RouteType? {
        guard let urlMatcherGroup = urlMatcherGroup else { return nil }
        for urlMatcher in urlMatcherGroup.matchers {
            if let route = try urlMatcher.match(url: url) {
                return route
            }
        }
        return nil
    }
    
    
}
