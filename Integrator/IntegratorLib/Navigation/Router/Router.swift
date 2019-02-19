//
//  Router.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

open class Router<Route: RouteType> { // TODO: Extract protocol?
    
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
    
    // An URL navigator to take care of URL related routing
    private let urlNavigator: URLNavigator<Route>
    
    // MARK: - Initialization
    
    /// Initialzation
    ///
    /// - Parameter navigationController: a navigation controller to hold the controllers of this flow
    required public init(navigationController: UINavigationController) {
        self.routesBuilder = RouteBuilder<Route>()
        self.navigator = Navigator<Route>(navigationController: navigationController, routesBuilder: self.routesBuilder)
        self.urlNavigator = URLNavigator<Route>(navigator: self.navigator)
    }
    
    /// Initialzation
    ///
    /// - Parameters:
    ///   - navigationController: a navigation controller to hold the controllers of this flow
    ///   - routesBuilder: someone to take care of the routes construction
    init(navigationController: UINavigationController, routesBuilder: RouteBuilder<Route>) {
        self.routesBuilder = routesBuilder
        self.navigator = Navigator<Route>(navigationController: navigationController, routesBuilder: routesBuilder)
        self.urlNavigator = URLNavigator<Route>(navigator: self.navigator)
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
    ///   - pathPattern: an URL pattern to match against a RouteType
    ///   - route: a routeType to match against an URL pattern
    public func map(_ pathPattern: PathPattern, toRouteResolver resolver: @escaping (MatchedURL) throws -> Route) {
        urlNavigator.associatePathPattern(pathPattern, toRouteResolver: resolver)
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
                  rootViewController: UIViewController? = nil,
                  animated: Bool,
                  presentationCompletion: ((Error?) -> Void)?,
                  dismissingCompletion: ((UIViewController?) -> Void)?) {
        navigator.navigate(to: route, rootViewController: rootViewController, customTransitionDelegate: customTransitionDelegate, animated: animated, presentationCompletion: presentationCompletion, dismissingCompletion: dismissingCompletion)
    }
    
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
                 animated: Bool = true,
                 presentationCompletion: ((Error?) -> Void)? = nil,
                 dismissingCompletion: ((UIViewController?) -> Void)? = nil) -> Bool {
        return urlNavigator.openURL(url,
                                    from: rootViewController,
                                    customTransitionDelegate: customTransitionDelegate,
                                    animated: animated,
                                    presentationCompletion: presentationCompletion,
                                    dismissingCompletion: dismissingCompletion)
    }
    
}
