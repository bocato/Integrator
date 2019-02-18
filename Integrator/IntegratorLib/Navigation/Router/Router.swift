//
//  Router.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

// MARK: - Types

public protocol RouterType {
    
    // MARK: - Properties
    
    /// The navigationController that starts the flow
    var navigationController: UINavigationController { get }
    
    /// Custom transition delegate
    var customTransitionDelegate: RouterCustomTransitionDelegate? { get set }
    
    // MARK: - Initialization
    
    /// Initialization
    ///
    /// - Parameter rootViewController: the controller that marks the start of the flow
    ///   - navigationController: the navigationController that starts the route
    init(navigationController: UINavigationController)
    
    // MARK: - Builders
    
    /// Registers a builder in order to create the result controller, i.e., the next scrreen
    ///
    /// - Parameters:
    ///   - builder: a closure that receives a route and returns a controller
    ///   - route: the route
    func register<Route: RouteType>(builder:  @escaping RouteBuilderClosure, forRouteType type: Route.Type)
    
    // MARK: - URL Routing
    
    /// Registers a url pattern in order to match with a RouteType
    ///
    /// - Parameters:
    ///   - urlPattern: an URL pattern to match against a RouteType
    ///   - route: a routeType to match against an URL pattern
    func register<Route: RouteType>(urlPattern: URLPathPattern, forRoute route: Route)
    
}

open class Router<Route: RouteType>: RouterType {
    
    // MARK: - Properties
    
    /// The navigationController that starts the flow
    public var navigationController: UINavigationController {
        return navigator.navigationController
    }
    
    /// Custom transition delegate
    public weak var customTransitionDelegate: RouterCustomTransitionDelegate?
    
    /// Route resolver, where the key is `RouteType` implementation
    private var routeBuildersClosures = [String: RouteBuilderClosure]()
    
    /// Routes builder, to take care of the building closures
    private let routesBuilder: RouteBuilder<Route>
    
    /// A navigator to take care of routing stuff
    private let navigator: Navigator<Route>
    
    // MARK: - Initialization
    
    /// Initialzation
    ///
    /// - Parameter navigationController: a navigation controller to hold the controllers of this flow
    required public init(navigationController: UINavigationController) {
        self.routesBuilder = RouteBuilder<Route>()
        self.navigator = Navigator<Route>(navigationController: navigationController, routesBuilder: routesBuilder)
    }
    
    
    /// Initialzation
    ///
    /// - Parameters:
    ///   - navigationController: a navigation controller to hold the controllers of this flow
    ///   - routesBuilder: someone to take care of the routes construction
    init(navigationController: UINavigationController, routesBuilder: RouteBuilder<Route>) {
        self.routesBuilder = routesBuilder
        self.navigator = Navigator<Route>(navigationController: navigationController, routesBuilder: routesBuilder)
    }
    
    // MARK: - Builders
    
    /// Registers a builder in order to create the result controller, i.e., the next scrreen
    ///
    /// - Parameters:
    ///   - builder: a closure that receives a route and returns a controller
    ///   - route: the route
    public func register<Route: RouteType>(builder: @escaping RouteBuilderClosure, forRouteType type: Route.Type) {
        routesBuilder.register(builder: builder, forRouteType: type)
    }
    
    // MARK: - URL Routing
    
    /// Registers a url pattern in order to match with a RouteType
    ///
    /// - Parameters:
    ///   - urlPattern: an URL pattern to match against a RouteType
    ///   - route: a routeType to match against an URL pattern
    public func register<Route: RouteType>(urlPattern: URLPathPattern, forRoute route: Route) {
        
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate using Enums
    ///
    /// - Parameters:
    ///   - route: an enum defining the possible routes
    ///   - rootViewController: a rootViewController to start the flow
    ///   - animated: true or false, as the systems default
    ///   - presentationCompletion: callback to identify if the navigation was successfull, after presentation
    ///   - dismissalCompletion: callback when the viewController is being dismissed
    func navigate(to route: Route,
                  rootViewController: UIViewController?,
                  animated: Bool,
                  presentationCompletion: ((Error?) -> Void)?,
                  dismissalCompletion: ((UIViewController?) -> Void)?) {
        
    }
    
}
