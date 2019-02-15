//
//  Integrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

/// An enum that defines an output to be passed on from
/// a child to it's parents over the responders Chain
public protocol IntegratorOutput {}

/// An enum that defines an input to be passed on from
/// the parent to it's childs
public protocol IntegratorInput {}

/// Defines a delegate to pass the outputs in the responder chain
public protocol IntegratorDelegate: AnyObject {
    
    /// Returns the child that just finished
    ///
    /// - Parameter child: the child that finished
    func childDidFinish(_ child: Integrator)
    
}

/// Defines an integrator for Controllers, or Integrators
public protocol Integrator: AnyObject, RouteResolver {
    
    // MARK: - Properties
    
    /// A Router to deal with navigation and URL parsing
    var router: RouterProtocol { get set }
    
    /// Delegate in order to implement the responder chain like communication
    var integratorDelegate: IntegratorDelegate? { get set }
    
    /// The parent integrator, i.e., who started this one
    ///
    /// - Note: this guy should be weak
    var parent: Integrator? { get set }
    
    /// The child integrators, i.e., the sub-flows of integration
    var childs: [Integrator]? { get set }
    
    // MARK: - Methods
    
    /// Starts the integration flow and calls registerViewControllerBuilders() to do it
    func start()
    
    //
    // MARK: - Output Operations
    //
    
    /// Receives an output from it's parent
    ///
    /// - Parameters:
    ///   - child: the child that has sent the output
    ///   - output: the output that was sent, it needs to conform with IntegratorOutput
    func receiveOutput(from child: Integrator, output: IntegratorOutput)
    
    //
    // MARK: - Input Operations
    //
    
    /// Receives an input from it's parent
    ///
    /// - Parameters:
    ///   - input: the output that was sent, it needs to conform with IntegratorInput
    ///
    /// - Note: This needs to be overriden in order to intercept the inputs from the parent
    func receiveInput(_ input: IntegratorInput)
    
}
public extension Integrator {

    // MARK: - Methods
    
    // Sets the initial route, and finishes when it is popped (when on a UINavigationController)
    public func setInitialRoute(_ route: RouteType, animated: Bool = true) {
        router.navigate(to: route, animated: true, presentationCompletion: { (optionalError) in
            if optionalError != nil {
                fatalError("Initial route was not configured... You need to implement it's resolver!")
            }
        }, dismissalCompletion: { _ in
            self.finish()
        })
    }
    
    /// Used to have a callback and clean up everything flow related
    public func finish() {
        integratorDelegate?.childDidFinish(self)
    }
    
    // MARK: - Child Operations
    
    /// Attachs a child integration flow
    ///
    /// - Parameters:
    ///   - child: the child to be attached
    ///   - completion: the completion handler to be called after attaching it
    /// - Returns: Void
    public func attachChild(_ child: Integrator, completion: (() -> ())? = nil) throws {
        if childs?.first(where: { $0.identifier == child.identifier }) != nil {
            throw IntegratorError.duplicatedChildFlow
        }
        child.parent = self
        childs?.append(child)
        completion?()
    }
    
    /// Dettachs a child flow and finishs it
    ///
    /// - Parameters:
    ///   - childIdentifier: the identifier of the child to be removed
    ///   - completion: the completion handler to be called after detaching the child
    public func detachChildWithIdentifier(_ childIdentifier: String, completion: (() -> ())? = nil) throws {
        guard let childToDettachIndex = childs?.firstIndex(where: { $0.identifier == childIdentifier }) else {
            throw IntegratorError.couldNotFindChildFlowWithIdentifier(childIdentifier)
        }
        childs?[childToDettachIndex].finish()
        childs?.remove(at: childToDettachIndex)
        completion?()
    }
    
    // MARK: - Output Operations
    
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
    
    // MARK: - Input Operations
    
    /// Sends an input to a designated Child
    ///
    /// - Parameters:
    ///   - childIdentifier: the child integrator
    ///   - input: a desired input object to be sent, it needs to conform with IntegratorOutput
    public func sendInputToChild(_ childIdentifier: String, input: IntegratorInput) throws {
        guard let childToSendTheInput = childs?.first(where: { $0.identifier == childIdentifier } ) else {
            throw IntegratorError.couldNotFindChildFlowWithIdentifier(childIdentifier)
        }
        childToSendTheInput.receiveInput(input)
    }
    
    /// Broadcast a designated input to all integrator childs
    ///
    /// - Parameter input:
    func broadcastInputToAllChilds(input: IntegratorInput) throws {
        childs?.forEach { $0.receiveInput(input) }
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
    public func receiveInput(_ input: IntegratorInput) {
        debugPrint("\(input) was received from \(parent?.identifier ?? "nobody, 'cause this guy doesn't have a parent!")")
    }
        
    // MARK: - Helpers
    
    public var identifier: String {
        return String(describing: type(of: self))
    }
    
}

public protocol ApplicationIntegrator: Integrator { // This one doesn't have a parentFlow
    /// - Note: Create the initialization omiting the parent, since there is
    ///         only one aplication integrator, being that, it won't have a parent.
}
public extension ApplicationIntegrator {
    public func finish() { fatalError("Application never ends.") }
}
