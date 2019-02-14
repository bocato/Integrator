//
//  AppIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 05/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class AppIntegrator: ApplicationIntegrator {
    
    // MARK: - Properties
    
    let router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]? = []
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        router.registerResolver(forRouteType: AppRoutes.self, resolver: executeBeforeTransition)
    }
    
    // MARK: - Integrator Methods
    func start() {
        
        router.navigate(to: AppRoutes.login, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
    }
    
}
// MARK: - RouteResolver
extension AppIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? AppRoutes else { 
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .homeTabBar(let tab):
            
            let homeTabBarIntegrator = HomeTabBarIntegrator(router: router, selectedTab: tab)
            
             do {
                
                try attachChild(homeTabBarIntegrator)
                homeTabBarIntegrator.start()
                
                return homeTabBarIntegrator.tabBarController
                
             } catch { throw error }

        case .login: return buildLoginViewController()
        }
        
    }
    
    // MARK: - Builders
    
    private func buildLoginViewController() -> UIViewController {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.delegate = self
        return loginViewController
    }
    
}


extension AppIntegrator: LoginViewControllerDelegate {
    
    func loginDidSucceed(in controller: LoginViewController) {
        
        // Using URLS
//        let homeTabBarURL = URL(string: "testapp://localhost/homeTabBar")! // Local
//            // URL(string: "http://integrator.test.com/homeTabBar") // WEB
//        router.openURL(homeTabBarURL, animated: true) { (error) in
//            debugPrint("error: \(error.debugDescription)")
//        }
//
        // Using Enums
        router.navigate(to: AppRoutes.homeTabBar(.home), animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
    }
    
}
