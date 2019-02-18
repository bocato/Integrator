//
//  URLPathPattern.swift
//  Integrator
//
//  Created by Eduardo Bocato on 18/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//  NOTE: This is from XRouter
//

import Foundation

/**
 Path pattern definition for pattern matching
 
 ```swift
 let pathPattern: PathPattern = "/my/{adjective}/string/{number}"
 
 pathPattern.matches("/my/cool/string/1")       // `true`
 pathPattern.matches("/my/awesome/string/2")    // `true`
 pathPattern.matches("/your/cool/string/3")     // `false`, mismatch on expected static element first
 pathPattern.matches("/my/cool/string/hello")   // `true`
 ```
 
 */
public class URLPathPattern: ExpressibleByStringLiteral, Hashable {
    
    
    //
    // MARK: - Properties
    //
    
    /// Get the individual parts
    public lazy var components: [Component] = {
        rawValue.components(separatedBy: "/")
            .compactMap { $0 == "" ? nil : $0 }
            .map { self.component(for: $0) }
    }()
    
    /// Raw string value
    private let rawValue: String
    
    //
    // MARK: - Methods
    //
    
    ///
    /// Initialize with string literal
    ///
    /// ```
    /// let pattern: PathPattern = "/check/{this}/out"
    /// ```
    ///
    required public init(stringLiteral: String) {
        rawValue = stringLiteral
    }
    
    //
    // MARK: - Hashable
    //
    
    /// Hashable
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    /// Compares on raw strings
    public static func == (lhs: URLPathPattern, rhs: URLPathPattern) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    //
    // MARK: - Implementation
    //
    
    /// Get the `Component` for some string
    private func component(for string: String) -> Component {
        
        if string == "*" {
            return .wildcard
        } else if string.first == "{" && string.last == "}" {
            let parameterName = string
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: "")
            return .parameter(named: parameterName)
        }
        
        return .exact(string: string)
    }
    
}
extension URLPathPattern: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return rawValue
    }
    
}

public extension URLPathPattern {
    
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
