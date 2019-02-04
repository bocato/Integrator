//
//  PathPattern+Component.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  OBS: Based on XRouter
//

import Foundation

public extension PathPattern {
    
    /**
     Path pattern component for pattern matching.
     */
    public enum Component {
        
        // MARK: - Component match type
        
        /// Exact match component
        case exact(string: String)
        
        /// Parameterized component
        case parameter(named: String)
        
        /// Wildcard (ignored) component
        case wildcard
        
        // MARK: - Methods
        
        /// Does this match some string
        func matches(_ foreignString: String) -> Bool {
            switch self {
            case .exact(let localString):
                return localString == foreignString
            case .wildcard, .parameter:
                return true
            }
        }
        
    }
    
}
