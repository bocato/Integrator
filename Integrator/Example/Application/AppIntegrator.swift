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
    weak var delegate: IntegratorDelegate?
    var parent: Integrator?
    var childs: [Integrator]? = []
    
    // MARK: - Initialization
    
    required init(router: RouterProtocol, parent: Integrator?) {
        
        self.router = router
        self.parent = parent
        
        registerViewControllerBuilders()
        
    }
    
    // MARK: - Integrator Methods
    
    func start() {
        
        router.navigate(to: Routes.login, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
    }
    
    // MARK: - Builders
    
    private func registerViewControllerBuilders() {
        router.registerBuilder(for: Routes.login, builder: loginViewControllerBuilder)
        router.registerBuilder(for: Routes.homeTabBar, builder: homeTabBarControllerBuilder)
    }
    
    private func loginViewControllerBuilder() -> UIViewController {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.delegate = self
        return loginViewController
    }
    
    private func homeTabBarControllerBuilder() -> UIViewController {
        
        let tabBarController = UITabBarController()
        
        let homeViewController = HomeViewController(labelText: "HomeViewController")
        let tabOneNavigationController = UINavigationController(rootViewController: homeViewController)
        
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let tabTwoNavigationController = UINavigationController(rootViewController: profileViewController)
        
        tabBarController.setViewControllers([
            tabOneNavigationController,
            tabTwoNavigationController
        ], animated: false)
        
        return tabBarController
    }
    
    //    private func configureRouteControllerBuilders() { // Think about this
    //        AppRoutes.allCases.forEach { router.registerBuilder(for: $0, builder: loginViewControllerBuilder) }
    //    }
}



extension AppIntegrator: LoginViewControllerDelegate {
    
    func loginDidSucceed(in controller: LoginViewController) {
        
        // Using URLS
        let homeTabBarURL = URL(string: "testapp://localhost/home")! // Local
            // URL(string: "http://integrator.test.com/home") // WEB
        router.openURL(homeTabBarURL, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
        // Using Enums
//        router.navigate(to: AppRoutes.homeTabBar, animated: true) { (error) in
//            debugPrint("error: \(error.debugDescription)")
//        }
        
    }
    
}
