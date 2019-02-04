//
//  AppRoutes.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

enum AppRoutes: RouteProvider {
    
    //
    case login
    case home
    case profile
    
    // MARK: - RouteProvider
    var transition: RouteTransition {
        <#code#>
    }
    
    func prepareForTransition<T>(from viewController: UIViewController) throws -> UIViewController {
        switch self {
        case .home:
            
        default:
            <#code#>
        }
    }
    
    
}
