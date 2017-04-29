//
//  NSLayoutConstraint+Active.swift
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

extension NSLayoutConstraint {

    /**
     Activates the constraint and returns a reference to it.
     */
    @discardableResult
    public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    /**
     Deactivates the constraint and returns a reference to it.
     */
    @discardableResult
    public func deactivate() -> NSLayoutConstraint {
        isActive = false
        return self
    }
    
}
