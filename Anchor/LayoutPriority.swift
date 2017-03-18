//
//  LayoutPriority.swift
//  Anchor
//
//  Created by Eddie Kaiger on 2/19/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

/**
 An enum representing common layout priorities.
 */
public enum LayoutPriority: Float {

    /// Represents a low layout priority with a value of 250.
    case low = 250

    /// Represents a medium layout priority with a value of 500.
    case medium = 500

    /// Represents a high layout priority with a value of 750.
    case high = 750

    /// Represents a required layout priority with a value of 1000. The default priority for constraints.
    case required = 1000
}

extension NSLayoutConstraint {

    /**
     Sets the layout priority for the constraint and returns a reference to self.
     - parameter    p:  The priority to set for the constraint.
     - returns:         The constraint (itself), with its priority updated.
     */
    @discardableResult
    public func withPriority(_ p: LayoutPriority) -> NSLayoutConstraint {
        return withPriority(p.rawValue)
    }

    /**
     Sets the layout priority for the constraint and returns a reference to self.
     - parameter    p:  The priority to set for the constraint.
     - returns:         The constraint (itself), with its priority updated.
     */
    @discardableResult
    public func withPriority(_ p: Float) -> NSLayoutConstraint {
        priority = p
        return self
    }

    /**
     Updates the layout priority for the constraint.
     - parameter    p:  The priority to set for the constraint.
    */
    public func updatePriority(_ p: LayoutPriority) {
        priority = p.rawValue
    }
    
}
