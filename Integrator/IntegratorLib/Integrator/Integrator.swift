//
//  Integrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

/// An enum that defines and output to be passed on from
/// a child to it's parent using kind of a Responder Chain
public protocol IntegratorOutput { }

/// Defines a delegate to pass the outputs in the responder chain
public protocol IntegratorDelegate: AnyObject {
    
    /// Receives an output from it's parent, having the possibility of intercepting
    /// it and doing something or passing it on to the next responder
    ///
    /// - Parameters:
    ///   - output: and output with data or messages to be passed on
    ///   - integrator: the integrator that has sent the output
    func receiveOutput(_ output: IntegratorOutput, fromIntegrator integrator: Integrator)

}

/// Defines an integrator for Controllers, or Integrators
public protocol Integrator {
    
    // MARK: - Properties
    
    /// A router to deal with navigation and URL parsing
    var router: RouterProtocol { get }
    
    /// Delegate in order to implement the responder chain like communication
    var delegate: IntegratorDelegate? { get set }
    
    /// The parent integrator, ie, who started this one
    var parent: Integrator? { get }
    
    
    // MARK: Initialization
    
    /// Builds an Integrator instance
    ///
    /// - Parameters:
    ///   - router: a router to deal with navigation and URL parsing
    ///   - parent: the parent, ie, the Integrator that started this flow
    init(router: RouterProtocol, parent: Integrator?)
    
    // MARK: - Methods
    
    /// Start the integration flow
    func start()
    
    /// Used to clean up everything flow related
    func finish()
    
    /// Aims to sent an output to the parent flows
    ///
    /// - Parameter output: the desired output to be sent
    func sendOutputToParent(_ output: IntegratorOutput)
    
    
    /// Receives an output from it's parent
    ///
    /// - Parameters:
    ///   - child: the child that has sent the output
    ///   - output: the output that was sent..
    func receiveOutput(from child: Integrator, output: IntegratorOutput)
    
}
public extension Integrator {
    
    /// Default implementation, in order to guarantee that the output is passed on
    ///
    /// - Parameter output: the desired output to be sent
    public func sendOutputToParent(_ output: IntegratorOutput) {
        parent?.receiveOutput(from: self, output: output)
    }
    
    /// Default implementation, in order to guarantee that the output is passed on.
    /// This needs to be overriden in order to intercept the outputs on the parents
    ///
    /// - Parameters:
    ///   - child: the child that has sent the output
    ///   - output: the output that was sent..
    ///
    /// - Example:
    ///    `func receiveOutput(from child: Integrator, output: IntegratorOutput) {
    ///        switch (child, output) {
    ///        case let (integrator as SomeIntegrator, output as SomeIntegrator.Output):
    ///            switch output {
    ///            case .someOutput:
    ///                // DO SOMETHING...
    ///                sendOutputToParent(output) // Pass it on if needed, or not...
    ///            }
    ///        default: return
    ///        }
    ///    }`
    ///
    public func receiveOutput(from child: Integrator, output: IntegratorOutput) {
        parent?.receiveOutput(from: self, output: output)
    }
    
    /// Finish function pre-implemetation... Override if needed.
    public func finish() { fatalError("This function should be overriden to be used!")}
    
}

public protocol ApplicationIntegrator: Integrator { // This one doesn't have a parentFlow
    
    /// Initialization omiting the parent, since there is only one aplication integrator,
    /// being that, it won't have a parent.
    ///
    /// - Parameter router: a router for the main flows
    init(router: RouterProtocol)
}
public extension ApplicationIntegrator {
    public func finish() { fatalError("Application never ends.") }
}
