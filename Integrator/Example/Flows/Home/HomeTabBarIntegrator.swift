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
    
    typealias Routes = AppRoutes.HomeTab
    
    // MARK: - Properties
    
    let router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]?
    
    var tabBarController: UITabBarController! // meh, check this
    
    // MARK: - Initialization
    
    init(router: RouterProtocol, tab: AppRoutes.HomeTab) {
        self.router = router
        router.registerResolver(forRouteType: Routes.self, resolver: executeBeforeTransition)
    }
    
    // MARK: - Required Methods
    
    func start() {
        router.navigate(to: Routes.home, rootViewController: nil, animated: true) { (error) in
            debugPrint("\(error.debugDescription)")
        }
    }
    
    // MARK: - Configure TabBar
    private func configureControllers(forTab tab: AppRoutes.HomeTab) { // meh, review this... just want it to work...
        tabBarController = UITabBarController()
        tabBarController.setViewControllers([HomeViewController(), ProfileViewController()], animated: false)
        switch tab {
        case .home:
            tabBarController.selectedIndex = 0
        case .profile:
            tabBarController.selectedIndex = 1
        }
    }
    
}
// MARK: - RouteResolver
extension HomeTabBarIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? Routes else { // TODO: Verify this
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .home: return tabBarController.viewControllers![0] // TODO: Check this...
        case .profile: return tabBarController.viewControllers![1] // TODO: Check this...
        }
        
    }
    
}

