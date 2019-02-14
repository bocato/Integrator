//
//  RouteResolver.swift
//  Integrator
//
//  Created by Eduardo Bocato on 13/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

public protocol RouteResolver {
    func prepareForTransition(to route: RouteType) throws -> UIViewController
}
extension RouteResolver {
    
    func prepareForTransition(to route: RouteType) throws -> UIViewController {
        throw RouterError.couldNotBuildViewControllerForRoute(named: route.name)
    }
    
}
