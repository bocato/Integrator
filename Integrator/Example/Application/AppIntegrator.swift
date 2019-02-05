//
//  AppIntegrator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 05/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

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
        let loginRoute = Routes.login(delegate: self)
        router.navigate(to: loginRoute, animated: true) { (error) in
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
