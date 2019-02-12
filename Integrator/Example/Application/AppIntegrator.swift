//
//  AppIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 05/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class AppIntegrator: ApplicationIntegrator {
    
    // MARK: - Aliases
    
    typealias Routes = AppRoutes
    
    // MARK: - Properties
    
    let router: RouterProtocol
    weak var integratorDelegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]? = []
    
    // MARK: - Initialization
    
    init(router: RouterProtocol) {
        self.router = router
        registerRouteBuilders()
    }
    
    // MARK: - Integrator Methods
    func start() {
        
        router.navigate(to: Routes.login, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
    }
    
}
extension AppIntegrator {
    
    // MARK: - Builders
    func registerRouteBuilders() {
        router.registerBuilder(for: Routes.login, builder: loginRouteBuilder)
        router.registerBuilder(for: Routes.homeTabBar, builder: homeTabBarBuilder)
    }
    
    private func loginRouteBuilder() -> UIViewController {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.delegate = self
        return loginViewController
    }
    
    private func homeTabBarBuilder() -> UIViewController {
        
        let tabBarController = UITabBarController()
        let homeTabBarRouter = Router<Routes.HomeTabBar>(rootViewController: tabBarController)
        let homeTabBarIntegrator = HomeTabBarIntegrator(router: homeTabBarRouter)
        
        do {
            try attachChild(homeTabBarIntegrator) {
                homeTabBarIntegrator.start()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return tabBarController
    }
    
}


extension AppIntegrator: LoginViewControllerDelegate {
    
    func loginDidSucceed(in controller: LoginViewController) {
        
        // Using URLS
        let homeTabBarURL = URL(string: "testapp://localhost/homeTabBar")! // Local
            // URL(string: "http://integrator.test.com/homeTabBar") // WEB
        router.openURL(homeTabBarURL, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
        // Using Enums
//        router.navigate(to: Routes.homeTabBar, animated: true) { (error) in
//            debugPrint("error: \(error.debugDescription)")
//        }
        
    }
    
}
