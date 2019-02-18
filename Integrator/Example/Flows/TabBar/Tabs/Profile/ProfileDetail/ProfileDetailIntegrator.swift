//
//  ProfileDetailIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 15/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class ProfileDetailIntegrator: Integrator {
    
    // MARK: - Aliases
    
    typealias Routes = AppRoutes.Tab.Profile.Detail
    
    // MARK: - Properties
    
    var router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    weak var parent: Integrator?
    var childs: [Integrator]?
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        router.register(resolver: executeBeforeTransition, forRouteType: AppRoutes.Tab.Profile.Detail.self)
    }
    
    // MARK: - Required Methods
    
    func start() {
        setInitialRoute(Routes.root)
    }
    
}
// MARK: - RouteResolver
extension ProfileDetailIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? Routes else { // TODO: Verify this
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .root:
            let profileDetailViewController = ProfileDetailViewController()
            return profileDetailViewController
        }
        
    }
    
}

