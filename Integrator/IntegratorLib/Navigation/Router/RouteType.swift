//
//  RouteType.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

public protocol RouteType { // Enum

    // MARK: - Properties
    
    /// Route name
    var name: String { get }
    
    /// Transition type
    var transition: RouteTransition { get }
    
}
extension RouteType {
    
    /// Route name, `login(username: String, password: String)` will become `login`
    public var name: String {
        return String(describing: self).components(separatedBy: "(")[0]
    }
    
    /// Transition type
    public var transition: RouteTransition {
        return .inferred
    }
    
}
extension RouteType {
    
    // MARK: - Equatable
    
    /// Equatable (default: Compares on `name` property)
    public static func == (_ lhs: RouteType, _ rhs: RouteType) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    
}
