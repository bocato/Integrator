//
//  IntegratorError.swift
//  Integrator
//
//  Created by Eduardo Bocato on 11/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation
/**
 Errors that can be thrown by an Integrator.
 */
public enum IntegratorError {
    
    //
    // MARK: - Errors
    //
    
    /// Signals that the developer is trying to attach a flow that is already in the stack
    case duplicatedChildFlow
    
    /// There is no child flow with the expected identifier
    case couldNotFindChildFlowWithIdentifier(String)
    
}

extension IntegratorError: LocalizedError {
    
    //
    // MARK: - LocalizedError
    //
    
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .duplicatedChildFlow:
            return """
            Attempted to use append an Integration flow that is already in running.
            """
        case .couldNotFindChildFlowWithIdentifier(let identifier):
            return """
            The expected flow (\(identifier)) is not on the stack/not running.
            """
        }
    }
    
    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? {
        switch self {
        case .duplicatedChildFlow:
            return """
            If you really need to attach a duplicated again, rethink about it...
            """
        case .couldNotFindChildFlowWithIdentifier(let identifier):
            return """
            You probably didn't attach a flow named \(identifier)), check your flow initialization code.
            """
        }
    }
    
}
