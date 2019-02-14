//
//  RoutingError.swift
//  Integrator
//
//  Created by Eduardo Bocato on 12/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation
/**
 Errors that can be thrown by Routing operations.
 */
public enum RoutingError {
    
    //
    // MARK: - Errors
    //
    
    /// There is no route with this name
    case couldNotFindRouteWithName(String)
    
}

extension RoutingError: LocalizedError {
    
    //
    // MARK: - LocalizedError
    //
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .couldNotFindRouteWithName(let name):
            return """
            There is no route named \(name)."
            """
        }
    }
    
    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        switch self {
        case .couldNotFindRouteWithName(let name):
            return """
            Check if the route named \(name) really exists.
            """
        }
    }
    
}
