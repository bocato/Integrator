//
//  Router.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

protocol RouterProtocol { // TODO: Create initialization?
    
    // MARK: - Properties
    
    /// The navigationController that starts the flow
    var navigationController: UINavigationController { get }
    
    /// The routes for this router
    var routes: Route { get }
    
    // MARK: - Navigation Methods
  
    /// Navigate
    ///
    /// - Parameters:
    ///   - route: an enum defining the possible routes
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    func navigate(to route: Route, animated: Bool, completion: ((Error?) -> Void)?)
    
    
    /// Navigate
    ///
    /// - Parameters:
    ///   - url: And URL that can be parsed to a pre-define route
    ///   - animated: true or false, as the systems default
    ///   - completion: callback to identify if the navigation was successfull
    func navigate(with url: URL, animated: Bool, completion: ((Error?) -> Void)?)
}

public class Router: RouterProtocol {
    
    // MARK: - Properties
    
    /// A navigationController that marks the start of the flow
    public let navigationController: UINavigationController
    
    /// The pre-defined routes
    public let routes: Route
    
    // MARK: - Initialization
    public init(navigationController: UINavigationController, routes: Route) {
        self.navigationController = navigationController
        self.routes = routes
    }
 
    // MARK: - Navigation Methods
    
    ///
    /// Navigate to a Route, using the route
    ///
    /// - Note: Has no effect if the destination view controller is the view controller or navigation controller
    ///         you are presently on - as provided by `RouteProvider(_:).prepareForTransition(...)`.
    ///
    open func navigate(to route: Route, animated: Bool = true, completion: ((Error?) -> Void)? = nil) {
        
    }
    
    open func navigate(with url: URL, animated: Bool, completion: ((Error?) -> Void)?) {
        
    }
    
    
    // MARK: - Implementation
    
    ///
    /// Prepare the route for navigation.
    ///
    ///     - Fetching the view controller we want to present
    ///     - Checking if its already in the view heirarchy
    ///         - Checking if it is a direct ancestor and then closing its children/siblings
    ///
    /// - Note: The completion block will not execute if we could not find a route
    ///
    private func prepareForNavigation(to route: Route,
                                      animated: Bool,
                                      successHandler: @escaping (_ source: UIViewController, _ destination: UIViewController) -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
    }
    
}
