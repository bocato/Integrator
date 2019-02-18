//
//  URLNavigator.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

internal class URLNavigator<Routes: RouteType> {
    
    // MARK: - Properties
    
    /// Navigator to "translate" the url's to routes, it is the one the knows the Routes for the app
    private let navigator: Navigator<Routes>
    
    // MARK: - Intialiser
    
    
    /// Initialises the URLNavigator
    ///
    /// - Parameter navigator: a navigator to "translate" the url's to routes
    init(navigator: Navigator<Routes>) {
        self.navigator = navigator
    }
    
    
    
}
