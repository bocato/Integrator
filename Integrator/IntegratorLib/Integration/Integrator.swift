//
//  Integrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

open class Integrator<Routes: RouteType>: IntegratorType {
    

    // MARK: - Properties
    
    public var integratorDelegate: IntegratorDelegate?
    public var parent: IntegratorType?
    public var childs: [IntegratorType]?
    public let router: Router<Routes>
    
    // MARK: - Initialization
    
    required public init(router: Router<Routes>) {
        self.router = router
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
    
}
