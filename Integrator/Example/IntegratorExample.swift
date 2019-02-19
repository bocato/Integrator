//
//  IntegratorExample.swift
//  Integrator
//
//  Created by Eduardo Bocato on 19/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

enum MyRoutes: RouteType {
    
    case home
    case login
    
}

class MyIntegrator: Integrator<MyRoutes> {
    
    override func start() {
        
    }
    
    override func executeBeforeTransition(to route: MyRoutes) throws -> UIViewController {
        switch route {
        case .home:
            return UIViewController()
        case .login:
            return UIViewController()
        }
    }
    
    func registerURLs() {
        router.map("login") { _ in return .login }
        router.map("home") { _ in return .home }
    }
    
}
