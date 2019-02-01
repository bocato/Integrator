//
//  Integrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

protocol IntegratorOutput { } // Enum, please
protocol IntegratorDelegate: AnyObject {
    func receiveOutput(_ output: IntegratorOutput, fromCoordinator coordinator: Integrator)
}

protocol Integrator {
    
    var router: RouterProtocol { get }
    var delegate: IntegratorDelegate? { get set }
    
    // MARK: - Properties
    var parent: Integrator? { get }
    
    // MARK: Functions
    init(router: RouterProtocol, parentFlow: Integrator?)
    func start() // Do i really need this?
    func finish() // Do i really need this?
    func sendOutputToParentFlow(_ output: IntegratorOutput)
    func receiveChildFlowOutput(child: Integrator, output: IntegratorOutput)
}

protocol ApplicationIntegrator: Integrator {} // This one doesn't have a parentFlow
extension ApplicationIntegrator {
    func finish() { fatalError("Application never ends.") }
}
