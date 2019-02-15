//
//  HomeIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class TabBarIntegrator: NSObject, Integrator {
    
    // MARK: - Aliases
    
    typealias Routes = AppRoutes.Tab
    
    // MARK: - Properties
    
    var router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    weak var parent: Integrator?
    var childs: [Integrator]?
    
    let tabBarController: UITabBarController!
    var selectedTab: AppRoutes.Tab
    
    // MARK: - Initialization
    
    init(router: RouterProtocol, selectedTab: AppRoutes.Tab) {
        self.router = router
        self.selectedTab = selectedTab
        tabBarController = ExampleTabBarController()
        super.init()
        router.registerResolver(forRouteType: AppRoutes.Tab.self, resolver: executeBeforeTransition)
    }
    
    // MARK: - Required Methods
    
    func start() {
        configureControllers(forTab: selectedTab)
        setInitialRoute(selectedTab)
    }
    
    // MARK: - Configure TabBar
    private func configureControllers(forTab tab: AppRoutes.Tab) { // meh, review this... just want it to work...
        
        tabBarController.delegate = self
        
        let homeTabNavigationController = UINavigationController()
        homeTabNavigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        
        let profileTabNavigationController = UINavigationController()
        profileTabNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 1)
        
        tabBarController.setViewControllers([homeTabNavigationController, profileTabNavigationController], animated: false)
        
        let homeTabRouter = Router<AppRoutes.Tab.Home>(navigationController: homeTabNavigationController)
        let homeIntegrator = HomeIntegrator(router: homeTabRouter)
        try? attachChild(homeIntegrator)
        homeIntegrator.start()
        
        let profileTabRouter = Router<AppRoutes.Tab.Profile>(navigationController: profileTabNavigationController)
        let profileIntegrator = ProfileIntegrator(router: profileTabRouter)
        try? attachChild(profileIntegrator)
        profileIntegrator.start()
        
        switch tab {
        case .home:
            tabBarController.selectedIndex = 0
        case .profile:
            tabBarController.selectedIndex = 1
        }
    }
    
}
// MARK: - UITabBarControllerDelegate
extension TabBarIntegrator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        guard let rootNavigationOfSomeTab = viewController as? UINavigationController, !rootNavigationOfSomeTab.viewControllers.isEmpty else {
            fatalError("Tabbar configuration failure.")
        }
    }
    
}

// MARK: - RouteResolver
extension TabBarIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? Routes else { // TODO: Verify this
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .home:
            tabBarController.selectedIndex = 0
        case .profile:
            tabBarController.selectedIndex = 1
        }
        return tabBarController
        
    }
    
}
extension TabBarIntegrator: IntegratorDelegate {
    
    func childDidFinish(_ child: Integrator) {
        debugPrint("\(child.identifier) just finished.")
    }
    
}

