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
    
    var router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    weak var parent: Integrator?
    var childs: [Integrator]? = []
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        router.register(resolver: executeBeforeTransition, forRouteType: AppRoutes.self)
    }
    
    // MARK: - Integrator Methods
    func start() {
        setInitialRoute(AppRoutes.login)
//        let homeTabBarURL = URL(string: "testapp://localhost/homeTabBar/home?text=MyHome")! // Local
//        router.openURL(homeTabBarURL, animated: true) { (error) in
//            debugPrint("error: \(error.debugDescription)")
//        }
    }
    
}
// MARK: - RouteResolver
extension AppIntegrator: RouteResolver {
    
    func executeBeforeTransition(to route: RouteType) throws -> UIViewController {
        
        guard let currentRoute = route as? AppRoutes else { 
            throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
        }
        
        switch currentRoute {
        case .tabBar(let tab):
            
            let tabBarIntegrator = TabBarIntegrator(router: router, selectedTab: tab)
            tabBarIntegrator.parent = self
            
            do {
                
                try attachChild(tabBarIntegrator)
                
                tabBarIntegrator.start()
                
                return tabBarIntegrator.tabBarController
                
            } catch {
                throw error
            }
        case .login:
            return buildLoginViewController()
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
//        let homeTabBarURL = URL(string: "testapp://localhost/homeTabBar/home?text=MyHome")! // Local
//            // URL(string: "http://integrator.test.com/homeTabBar/home/text?=MyHome") // WEB
//        router.openURL(homeTabBarURL, animated: true) { (error) in
//            debugPrint("error: \(error.debugDescription)")
//        }

        // Using Enums
        router.navigate(to: AppRoutes.tabBar(.home(.root)),
                        rootViewController: nil,
                        animated: true,
                        presentationCompletion: { (error) in
                            debugPrint("error: \(error.debugDescription)")
        },
                        dismissalCompletion: { dismissedViewController in
                            debugPrint(String(describing: dismissedViewController))
        })
        
    }
    
}
