//
//  HomeIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

class HomeTabBarIntegrator: Integrator {
    
    // MARK: - Properties
    
    let router: RouterProtocol
    var delegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]?
    
    // MARK: - Initialization
    
    init(router: RouterProtocol, parent: Integrator) {
        self.router = router
        self.parent = parent
        registerRouteBuilders()
    }
    
    // MARK: - Required Methods
    
    func start() {
        
    }
    
    func registerRouteBuilders() {
        
    }
    
    
}
