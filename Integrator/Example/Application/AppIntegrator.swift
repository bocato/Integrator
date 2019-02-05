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
    
    // MARK: - Initialization
    
    required init(router: RouterProtocol, parent: Integrator?) {
        self.router = router
        self.parent = parent
    }

    func start() {
        
        router.registerViewControllerBuilder(for: Routes.login) { () -> UIViewController in
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            loginViewController.delegate = self
            return loginViewController
        }
        
        router.navigate(to: Routes.login, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
        
    }
    
}
extension AppIntegrator: LoginViewControllerDelegate {
    
    func loginDidSucceed(in controller: LoginViewController) {
        router.navigate(to: AppRoutes.home, animated: true) { (error) in
            debugPrint("error: \(error.debugDescription)")
        }
    }
    
}
