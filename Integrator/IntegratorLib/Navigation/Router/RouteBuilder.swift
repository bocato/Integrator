//
//  RouteBuilder.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

/// A route resolver type
public typealias RouteBuilderClosure = (_ route: RouteType) throws -> UIViewController

internal class RouteBuilder<Route: RouteType> {
    
    // MARK: - Properties
    
    private(set) var routeBuildersClosures: [String: RouteBuilderClosure]
    
    // MARK: - Initialization
    init(routeBuildersClosures: [String: RouteBuilderClosure] = [:]) {
        self.routeBuildersClosures = routeBuildersClosures
    }
    
    // MARK: - Methods
    
    /// Registers a builder in order to create the result controller, i.e., the next scrreen
    ///
    /// - Parameters:
    ///   - builder: a closure that receives a route and returns a controller
    ///   - route: the route
    func register<Route: RouteType>(builder: @escaping RouteBuilderClosure, forRouteType type: Route.Type) {
        let routeTypeName = String(describing: type)
        routeBuildersClosures[routeTypeName] = builder
    }
    
    /// Resolve the controller for the route
    ///
    /// - Parameter route: a route, conforming with the provider
    /// - Returns: the configured ViewController
    /// - Throws: an error telling us if the route could not be built
    private func findBuilderForRoute(_ route: Route) throws -> RouteBuilderClosure {
        let routeTypeName = String(describing: type(of: route))
        guard let builder = routeBuildersClosures[routeTypeName] else {
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        return builder
    }
    
    /// Gets a configuerd controller for a defined route, if the said route is configured
    ///
    /// - Parameter route: the route you want to resolve
    /// - Returns: a configuredViewControler for the expected route
    /// - Throws: and error if the builder is not configured
    func buildControllerForRoute(_ route: Route) throws -> UIViewController {
        
        let routeBuilderClosure: RouteBuilderClosure
        do {
            routeBuilderClosure = try findBuilderForRoute(route)
        } catch {
            throw error
        }
        
        let controler: UIViewController
        do {
            controler = try routeBuilderClosure(route)
        } catch {
            throw error
        }
        
        return controler
        
    }
    
}
