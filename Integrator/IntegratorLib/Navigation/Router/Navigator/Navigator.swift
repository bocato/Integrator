//
//  Navigator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

internal class Navigator<Route: RouteType>: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    /// The navigationController that starts the flow
    private(set) var navigationController: UINavigationController
    
    /// Someone to take care of the routes construction
    private let routesBuilder: RouteBuilder<Route>
    
    // Completions to run when the ViewControllers are dismissing
    private var dismissingCompletions: [UIViewController: (UIViewController?) -> Void]
    
    // MARK: - Initialization
    
    required public init(navigationController: UINavigationController, routesBuilder: RouteBuilder<Route>) {
        self.navigationController = navigationController
        self.routesBuilder = routesBuilder
        self.dismissingCompletions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate, using the route enum
    ///
    /// - Note: Has no effect if the destination view controller is the view controller
    ///         or navigation controller you are presently on.
    ///
    open func navigate(to route: Route,
                       rootViewController: UIViewController? = nil,
                       customTransitionDelegate: RouterCustomTransitionDelegate?,
                       animated: Bool = true,
                       presentationCompletion: ((Error?) -> Void)? = nil,
                       dismissingCompletion: ((UIViewController?) -> Void)? = nil) {
        
        let routeRootController = rootViewController ?? navigationController
        
        prepareForNavigation(to: route,
                             rootViewController: routeRootController,
                             animated: animated,
                             successHandler: {  (source, destination) in
                                self.performNavigation(from: source,
                                                       to: destination,
                                                       with: route.transition,
                                                       animated: animated,
                                                       presentationCompletion: presentationCompletion,
                                                       dismissingCompletion: dismissingCompletion)
        }, errorHandler: { error in
            presentationCompletion?(error)
        })
    }
    
    // MARK: - Implementation
    
    ///
    /// Prepare the route for navigation.
    ///
    ///     - Fetching the view controller we want to present
    ///     - Checking if its already in the view heirarchy
    ///         - Checking if it is a direct ancestor and then closing its children/siblings
    ///
    /// - Note: The completion block will not execute if we could not find a route
    ///
    private func prepareForNavigation(to route: Route,
                                      rootViewController: UIViewController?,
                                      animated: Bool,
                                      successHandler: @escaping (_ source: UIViewController, _ destination: UIViewController) -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
        
        guard let source = UIViewController.getTopViewController(for: rootViewController) else {
            errorHandler(RouterError.missingSourceViewController)
            return
        }
        
        let destination: UIViewController
        do {
            destination = try routesBuilder.buildControllerForRoute(route)
        } catch {
            errorHandler(error)
            return
        }
        
        guard let nearestAncestor = source.getLowestCommonAncestor(with: destination) else {
            // No common ancestor - Adding destination to the stack for the first time
            successHandler(source, destination)
            return
        }
        
        // Clear modal - then prepare for child view controller.
        nearestAncestor.transition(toDescendant: destination, animated: animated) {
            successHandler(nearestAncestor.visibleViewController, destination)
        }
        
    }
    
    /// Perform navigation
    private func performNavigation(from source: UIViewController,
                                   to destination: UIViewController,
                                   with transition: RouteTransition,
                                   transitionDelegate: RouterCustomTransitionDelegate? = nil,
                                   animated: Bool,
                                   presentationCompletion: ((Error?) -> Void)? = nil,
                                   dismissingCompletion: ((UIViewController?) -> Void)? = nil) {
        
        // Already here/on current navigation controller
        if destination === source || destination === source.navigationController {
            // No error? -- maybe throw an "already here" error
            presentationCompletion?(nil)
            return
        }
        
        // The source view controller will be the navigation controller where
        //  possible - but will otherwise default to the current view controller
        //  i.e. for "present" transitions.
        let source = source.navigationController ?? source
        
        // Then, rund the transition
        switch transition {
        case .push:
            pushTransition(source, destination, animated, presentationCompletion, dismissingCompletion)
        case .set:
            if source is UINavigationController {
                setTransition(source, destination, animated, presentationCompletion)
            } else if source is UITabBarController {
                // TODO: check this...
                debugPrint("UITabBarController")
            }
        case .present:
            modalTransition(source, destination, animated, presentationCompletion)
        case .inferred:
            if source is UITabBarController {
                // TODO: check this...
                debugPrint("UITabBarController")
            } else {
                inferTransition(source, destination, animated, presentationCompletion, dismissingCompletion)
            }
        case .custom:
            customTransition(transition, transitionDelegate, source, destination, animated, presentationCompletion)
        }
    }
    
    // MARK: - Transitions
    
    /// Infer transition from context
    private func inferTransition(_ source: UIViewController,
                                 _ destination: UIViewController,
                                 _ animated: Bool,
                                 _ presentationCompletion: ((Error?) -> Void)?,
                                 _ dismissalCompletion: ((UIViewController?) -> Void)?) {
        if (source as? UINavigationController) == nil || (destination as? UINavigationController) != nil {
            modalTransition(source, destination, animated, presentationCompletion)
        } else if destination.navigationController == source {
            setTransition(source, destination, animated, presentationCompletion)
        } else {
            pushTransition(source, destination, animated, presentationCompletion, dismissalCompletion)
        }
    }
    
    /// Push transition
    private func pushTransition(_ source: UIViewController,
                                _ destination: UIViewController,
                                _ animated: Bool,
                                _ presentationCompletion: ((Error?) -> Void)?,
                                _ dismissingCompletion: ((UIViewController?) -> Void)?) {
        
        guard let navController = source as? UINavigationController else {
            presentationCompletion?(RouterError.missingRequiredNavigationController(for: .push))
            return
        }
        
        // Set the dismissal completion
        if let dismissingCompletion = dismissingCompletion {
            dismissingCompletions[destination] = dismissingCompletion
        }
        
        navController.pushViewController(destination, animated: animated) {
            presentationCompletion?(nil)
        }
    }
    
    /// Set transition
    private func setTransition(_ source: UIViewController,
                               _ destination: UIViewController,
                               _ animated: Bool,
                               _ completion: ((Error?) -> Void)?) {
        guard let navController = source as? UINavigationController else {
            completion?(RouterError.missingRequiredNavigationController(for: .set))
            return
        }
        
        let viewControllers: [UIViewController]
        
        if let index = navController.viewControllers.firstIndex(of: destination) {
            //
            // Pop all view controllers above the destination
            //
            viewControllers = Array(navController.viewControllers[...index])
        } else {
            //
            // Set destination
            //
            viewControllers = [destination]
        }
        
        navController.setViewControllers(viewControllers, animated: animated) {
            completion?(nil)
        }
    }
    
    /// Modal transition
    private func modalTransition(_ source: UIViewController,
                                 _ destination: UIViewController,
                                 _ animated: Bool,
                                 _ completion: ((Error?) -> Void)?) {
        source.present(destination, animated: animated) {
            completion?(nil)
        }
    }
    
    /// Custom transition
    private func customTransition(_ transition: RouteTransition,
                                  _ delegate: RouterCustomTransitionDelegate?,
                                  _ source: UIViewController,
                                  _ destination: UIViewController,
                                  _ animated: Bool,
                                  _ completion: ((Error?) -> Void)?) {
        
        guard let delegate = delegate else {
            completion?(RouterError.missingCustomTransitionDelegate)
            return
        }
        
        delegate.performTransition(to: destination,
                                   from: source,
                                   transition: transition,
                                   animated: animated,
                                   completion: completion)
    }
    
    // MARK: - Helpers
    
    fileprivate func runDismissingCompletion(for controller: UIViewController) {
        guard let completion = dismissingCompletions[controller] else { return }
        completion(controller)
        dismissingCompletions.removeValue(forKey: controller)
    }
    
    // MARK: - Back action handling
    
    private func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // We’re still here – it means we’re popping the view controller
        runDismissingCompletion(for: viewController)
        
    }
    
}
