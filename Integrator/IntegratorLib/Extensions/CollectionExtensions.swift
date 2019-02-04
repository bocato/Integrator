//
//  CollectionExtensions.swift
//  Integrator
//
//  Created by Eduardo Bocato on 01/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /// Source: https://stackoverflow.com/a/30593673
    /// Authors: Nikita Kukushkin, Shaheen Ghiassy
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
