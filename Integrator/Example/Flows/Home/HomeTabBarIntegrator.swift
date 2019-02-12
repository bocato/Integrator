//
//  HomeIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class HomeTabBarIntegrator: Integrator {
    
    // MARK: - Aliases
    
    typealias Routes = AppRoutes.HomeTabBar
    
    // MARK: - Properties
    
    let router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
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
        router.navigate(to: Routes.home, animated: true) { (error) in
            debugPrint("\(error.debugDescription)")
        }
    }
    
    func registerRouteBuilders() {
        router.registerBuilder(for: Routes.home, builder: homeRouteBuilder)
        router.registerBuilder(for: Routes.profile, builder: profileRouteBuilder)
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
