//
//  HomeIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class HomeTabBarIntegrator: Integrator {
    
    // MARK: - Properties
    
    let router: RouterProtocol
    var delegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]?
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        registerRouteBuilders()
    }
    
    // MARK: - Required Methods
    
    func start() {
        registerRouteBuilders()
    }
    
    func registerRouteBuilders() {
        router.registerBuilder(for: HomeTabBarRoutes.home, builder: homeRouteBuilder)
        router.registerBuilder(for: HomeTabBarRoutes.profile, builder: profileRouteBuilder)
    }
    
    // MARK: - Builders
    
    private func homeRouteBuilder() -> UIViewController {
        let homeViewController = HomeViewController(centerLabelText: "HOME TEXT!")
        return homeViewController
    }
    
    private func profileRouteBuilder() -> UIViewController {
        let profileViewController = ProfileViewController()
        return profileViewController
    }
    
}
