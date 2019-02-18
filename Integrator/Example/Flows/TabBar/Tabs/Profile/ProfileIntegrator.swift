//
//  ProfileIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 15/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class ProfileIntegrator: Integrator {
    
    // MARK: - Aliases
    
    typealias Routes = AppRoutes.Tab.Profile
    
    // MARK: - Properties
    
    var router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    weak var parent: Integrator?
    var childs: [Integrator]?
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        router.register(resolver: executeBeforeTransition, forRouteType: AppRoutes.Tab.Profile.self)
    }
    
    // MARK: - Required Methods
    
    func start() {
        setInitialRoute(Routes.root)
    }
    
}
// MARK: - RouteResolver
extension ProfileIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? Routes else { // TODO: Verify this
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .root:
            let profileViewController = ProfileViewController()
            profileViewController.delegate = self
//            router.navigationController.viewControllers = [profileViewController]
//            return router.navigationController
            return profileViewController
        case .details:
            
            let profileDetailViewController = ProfileDetailViewController()
            return profileDetailViewController
        }
        
    }
    
}
extension ProfileIntegrator: ProfileViewControllerDelegate {
    
    func showDetailsButtonDidReceiveTouchUpInside() {
        let profileDetailIntegrator = ProfileDetailIntegrator(router: router)
        try? attachChild(profileDetailIntegrator)
        profileDetailIntegrator.start()
    }
    
}

