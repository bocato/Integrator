//
//  RouterError.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import Foundation

/**
 Errors that can be thrown by Router.
 */
public enum RouterError {
    
    //
    // MARK: - Errors
    //
    
    /// Used a custom transition but no custom transition delegate was set
    case missingCustomTransitionDelegate
    
    /// The route transition can only be called from a UINavigationController
    case missingRequiredNavigationController(for: RouteTransition)
    
    /// Missing required parameter while unwrapping URL route
    case missingRequiredParameterWhileUnwrappingURLRoute(parameter: String)
    
    /// There is currently no top view controller on the navigation stack
    /// - Note: This really won't ever occur, unless you are doing something super bizarre with the `UIWindow(_:).rootViewController`.
    case missingSourceViewController
    
    /// A required parameter was found, but it was not an Int
    case requiredIntegerParameterWasNotAnInteger(parameter: String, stringValue: String)
    
    /// Defines an error when the resolver is not configured
    case couldNotFindResolverForRoute(RouteType)
    
    /// A represents an error when the builder is not configured
    case couldNotBuildViewControllerForRoute(named: String)
    
    /// There is no possible route configured for this pattern
    case couldNotFindRouteForPattern(String)
    
}

extension RouterError: LocalizedError {
    
    //
    // MARK: - LocalizedError
    //
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .missingCustomTransitionDelegate:
            return """
            Attempted to use a custom transition, but `customTransitionDelegate` was set to `nil`.
            """
        case .missingRequiredNavigationController(let transition):
            return """
            You cannot navigate to this route using transition \"\(transition.name)\" without a navigation controller.
            """
        case .missingRequiredParameterWhileUnwrappingURLRoute(let name):
            return """
            Missing required paramter \"\(name)\" while unwrapping URL route.
            """
        case .missingSourceViewController:
            return """
            The source view controller (AKA current top view controller) was unexpectedly `nil`.
            This could be because the top view controller is an empty navigation controller.
            """
        case .requiredIntegerParameterWasNotAnInteger(let name, let stringValue):
            return """
            Required integer parameter \"\(name)\" existed, but was not an integer.
            Instead \"\(stringValue)\" was received."
            """
        case .couldNotFindResolverForRoute(let route):
            return """
            There is no configured resolver for \(String(describing: route))"
            """
        case .couldNotBuildViewControllerForRoute(let routeName):
            return """
            The view controller for "\(routeName)" could not be built."
            """
        case .couldNotFindRouteForPattern(let pattern):
            return """
            There is no route configured for the pattern below:
            \(pattern.debugDescription)
            """
        }
    }
    
    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        switch self {
        case .missingCustomTransitionDelegate:
            return """
            Set `customTransitionDelegate` when using `RouteTransition.custom(_:)`.
            """
        case .missingRequiredNavigationController:
            return """
            Nest the parent view controller in a `UINavigationController`.
            """
        case .missingRequiredParameterWhileUnwrappingURLRoute(let name):
            return """
            You referenced a parameter \"\(name)\" that wasn't declared in the `PathPattern`.
            Please include the parameter in `PathPattern`, or remove it from the mapping.
            """
        case .missingSourceViewController:
            return """
            Something unexpected has happened and the source view controller was not able to be located.
            """
        case .requiredIntegerParameterWasNotAnInteger(_, let stringValue):
            return """
            The value that was received was \"\(stringValue)\", which could not be cast to `Int`.
            """
        case .couldNotFindResolverForRoute(let route):
            return """
            You should check if there is a resolver registered for \(String(describing: route))"
            """
        case .couldNotBuildViewControllerForRoute(let routeName):
            return """
            The view controller for "\(routeName)" could not be built, please
            check if you have registered it's builder properly."
            """
        case .couldNotFindRouteForPattern(let pattern):
            return """
            There is no route configured for the pattern below:
            \(pattern)
            Check its configuration.
            """
        }
    }
    
}
