//
//  NSLayoutConstraint+AnchorKit.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/19/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

extension NSLayoutConstraint {

    /**
     Activates the constraint and returns self.
     - returns:     A reference to self.
     */
    @discardableResult
    public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    /**
     Deactivates the constraint and returns self.
     - returns:     A reference to self.
     */
    @discardableResult
    public func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }

    /**
     Updates the offset of the constraint and returns self.
     - parameter    offset: The constant to use for the constraint.
     - returns:             A reference to self.
     */
    @discardableResult
    public func offset(_ offset: CGFloatRepresentable) -> NSLayoutConstraint {
        constant = offset.cgFloatValue
        return self
    }

    /**
     Sets the inset of the constraint and returns self.
     - parameter    inset:  For constraints in which the first anchor is the bottom, right, or trailing anchor, this creates a negative offset. Otherwise, acts identical to `offset(_:)`.
     - returns:             A reference to self.
     */
    @discardableResult
    public func inset(_ inset: CGFloatRepresentable) -> NSLayoutConstraint {
        switch firstAttribute {
        case .bottom, .right, .trailing:
            offset(-inset.cgFloatValue)
        default:
            offset(inset)
        }
        return self
    }

    /**
     Updates the inset of the constraint. Identical to `inset(_:)`, but has no return value (for proper naming conventions, use this when actually updating a constraint, and use `inset(_:)` during constraint creation).
     - parameter    inset:  For constraints in which the first anchor is the bottom, right, or trailing anchor, this creates a negative offset. Otherwise, acts identical to `offset(_:)`.
     */
    public func updateInset(_ inset: CGFloatRepresentable) {
        self.inset(inset)
    }

}

extension Sequence where Iterator.Element == NSLayoutConstraint {

    /**
     Updates the offset of the constraints and returns self.
     - parameter    offset: The constant to use for the constraints.
     - returns:             A reference to self.
     */
    @discardableResult
    public func offset(_ offset: CGFloatRepresentable) -> Self {
        forEach { $0.offset(offset) }
        return self
    }

    /**
     Updates the inset of the constraints and returns self.
     - parameter    inset:  For constraints in which the first anchor is the bottom, right, or trailing anchor, this creates a negative offset. Otherwise, acts identical to `offset(_)`.
     - returns:             A reference to self.
     */
    @discardableResult
    public func inset(_ inset: CGFloatRepresentable) -> Self {
        forEach { $0.inset(inset) }
        return self
    }

}
