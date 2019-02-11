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
    
    //
    // MARK: - Properties
    //
    
    /// A router to deal with navigation and URL parsing
    var router: RouterProtocol { get }
    
    /// Delegate in order to implement the responder chain like communication
    var delegate: IntegratorDelegate? { get set }
    
    /// The parent integrator, i.e., who started this one
    var parent: Integrator? { get set }
    
    /// The child integrators, i.e., the sub-flows of integration
    var childs: [Integrator]? { get set }
    
    //
    // MARK: Initialization
    //
    
    /// Builds an Integrator instance
    ///
    /// - Parameters:
    ///   - router: a router to deal with navigation and URL parsing
    ///   - parent: the parent, ie, the Integrator that started this flow
    init(router: RouterProtocol, parent: Integrator?)
    
    //
    // MARK: - Methods
    //
    
    /// Start the integration flow
    func start()
    
    /// Used to clean up everything flow related
    func finish()
    
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
    
    /// Sends an input to a designated Child
    ///
    /// - Parameters:
    ///   - childIdentifier: the child integrator
    ///   - input: a desired input object to be sent, it needs to conform with IntegratorOutput
    func sendInputToChild(_ childIdentifier: String, input: IntegratorInput) throws
    
    /// Broadcast a designated input to all integrator childs
    ///
    /// - Parameter input:
    func broadcastInputToAllChilds(input: IntegratorInput) throws
    
    /// Receives an input from it's parent
    ///
    /// - Parameters:
    ///   - input: the output that was sent, it needs to conform with IntegratorInput
    ///
    /// - Note: This needs to be overriden in order to intercept the inputs from the parent
    func receiveInput(_ input: IntegratorInput)
    
}
public extension Integrator {
    //
    // MARK: - Helpers
    //
    public var identifier: String {
        return String(describing: type(of: self))
    }
    
    //
    // MARK: - Methods
    //
    
    /// Finish function pre-implemetation... Override if needed.
    public func finish() { fatalError("This function should be overriden to be used!")}
    
    //
    // MARK: - Child Operations
    //
    
    /// Attachs a child integration flow
    ///
    /// - Parameters:
    ///   - child: the child to be attached
    ///   - completion: the completion handler to be called after attaching it
    /// - Returns: Void
    public mutating func attachChild(_ child: Integrator, completion: (() -> ())? = nil) throws {
        if childs?.first(where: { $0.identifier == child.identifier }) != nil {
            throw IntegratorError.duplicatedChildFlow
        }
        var childToAdd = child
        childToAdd.parent = self
        childs?.append(childToAdd)
        completion?()
    }
    
    /// Dettachs a child flow and finishs it
    ///
    /// - Parameters:
    ///   - childIdentifier: the identifier of the child to be removed
    ///   - completion: the completion handler to be called after detaching the child
    public mutating func detachChildWithIdentifier(_ childIdentifier: String, completion: (() -> ())? = nil) throws {
        guard let childToDettachIndex = childs?.firstIndex(where: { $0.identifier == childIdentifier }) else {
            throw IntegratorError.couldNotFindChildFlowWithIdentifier(childIdentifier)
        }
        childs?[childToDettachIndex].finish()
        childs?.remove(at: childToDettachIndex)
        completion?()
    }
    
    //
    // MARK: - Output Operations
    //
    
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
    
    //
    // MARK: - Input Operations
    //
    
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
    
}

public protocol ApplicationIntegrator: Integrator { // This one doesn't have a parentFlow
    /// - Note: Create the nitialization omiting the parent, since there is
    ///         only one aplication integrator, being that, it won't have a parent.
}
public extension ApplicationIntegrator {
    public func finish() { fatalError("Application never ends.") }
}
