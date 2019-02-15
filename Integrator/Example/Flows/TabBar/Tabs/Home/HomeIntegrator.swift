//
//  HomeIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 15/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class HomeIntegrator: Integrator {
    
    // MARK: - Aliases
    
    typealias Routes = AppRoutes.Tab.Home
    
    // MARK: - Properties
    
    var router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    weak var parent: Integrator?
    var childs: [Integrator]?
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        router.registerResolver(forRouteType: AppRoutes.Tab.Home.self, resolver: executeBeforeTransition)
    }
    
    // MARK: - Required Methods
    
    func start() {
        setInitialRoute(Routes.root)
    }
    
}
// MARK: - RouteResolver
extension HomeIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? Routes else { // TODO: Verify this
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .root:
            let homeViewController = HomeViewController()
            return homeViewController
        }
        
    }
    
}
