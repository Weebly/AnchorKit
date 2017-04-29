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
public enum LayoutPriority: RawRepresentable {

    /// Represents a low layout priority with a value of 250.
    case low

    /// Represents a medium layout priority with a value of 500.
    case medium

    /// Represents a high layout priority with a value of 750.
    case high

    /// Represents a required layout priority with a value of 1000. The default priority for constraints.
    case required

    /// Represents a layout priority with a custom value.
    case custom(Float)

    /**
     Creates a new layout priority with the given priority value.
     */
    public init(rawValue: Float) {
        switch rawValue {
        case 250: self = .low
        case 500: self = .medium
        case 750: self = .high
        case 1000: self = .required
        default: self = .custom(rawValue)
        }
    }

    /// The value of the layout priority.
    public var rawValue: Float {
        switch self {
        case .low: return 250
        case .medium: return 500
        case .high: return 750
        case .required: return 1000
        case .custom(let value): return value
        }
    }

}

public func + (lhs: LayoutPriority, rhs: Float) -> LayoutPriority {
    return LayoutPriority(rawValue: lhs.rawValue + rhs)
}

public func - (lhs: LayoutPriority, rhs: Float) -> LayoutPriority {
    return lhs + (-rhs)
}

extension NSLayoutConstraint {

    /// The layout priority of the constraint.
    public var layoutPriority: LayoutPriority {
        set {
            priority = newValue.rawValue
        }
        get {
            return LayoutPriority(rawValue: priority)
        }
    }
    
}
