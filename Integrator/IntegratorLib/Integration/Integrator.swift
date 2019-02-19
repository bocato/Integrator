//
//  Integrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

open class Integrator<Route: RouteType>: IntegratorType {
    
    
    // MARK: - Properties
    
    public var integratorDelegate: IntegratorDelegate?
    public var parent: IntegratorType?
    public var childs: [IntegratorType]?
    public let router: Router<Route>
    
    // MARK: - Initialization
    
    required public init(router: Router<Route>) {
        self.router = router
        router.register(builder: executeBeforeTransitionToRouteType, forRouteType: Route.self)
    }
    
    // MARK: - Methods
    
    /// Starts the integration flow
    /// - Note: Needs to be overriden
    public func start() {
        fatalError("This method needs to be overriden!")
    }
    
    /// Default implementation, in order to guarantee that the output is passed on.
    /// This needs to be overriden in order to intercept the outputs on the parents
    ///
    /// - Parameters:
    ///   - child: the child that has sent the output
    ///   - output: the output that was sent..
    ///
    /// - Example:
    ///    `override func receiveInput(_ input: IntegratorInput) {
    ///        switch (input) {
    ///        case .someInput:
    ///        // DO SOMETHING
    ///        }
    ///    }`
    ///
    public func receiveInput(_ input: IntegratorType) {
        debugPrint("\(input) was received from \(parent?.identifier ?? "nobody")")
    }
    
    /// This is executed in order to provide a controller before the transition
    ///
    /// - Parameter route:
    /// - Returns: a configured controller
    /// - Throws: an error if the route is not yet configured
    private func executeBeforeTransitionToRouteType(_ route: RouteType) throws -> UIViewController {
        guard let transitionRoute = route as? Route else {
            throw RouterError.unableToCastRouteType
        }
        return try executeBeforeTransition(to: transitionRoute)
    }
    
    /// This is executed in order to provide a controller before the transition
    ///
    /// - Parameter route:
    /// - Returns: a configured controller
    /// - Throws: an error if the route is not yet configured
    ///
    /// - Note: Needs to be overriden.
    public func executeBeforeTransition(to route: Route) throws -> UIViewController {
        fatalError("This method needs to be overriden, and the routes need to be configured.")
    }
    
}
