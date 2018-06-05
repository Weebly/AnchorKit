//
//  NSLayoutConstraint+AnchorKit.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/19/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
    #if swift(>=3.2)
        public typealias EdgeInsets = NSEdgeInsets
        public typealias LayoutAttribute = NSLayoutConstraint.Attribute
    #else
        public typealias EdgeInsets = Foundation.EdgeInsets
        public typealias LayoutAttribute = NSLayoutAttribute
    #endif
#else
    import UIKit
    public typealias EdgeInsets = UIEdgeInsets
    #if swift(>=4.2)
        public typealias LayoutAttribute = NSLayoutConstraint.Attribute
    #else
        public typealias LayoutAttribute = NSLayoutAttribute
    #endif
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
     Updates the offset (constant) of the constraint and returns self.
     - parameter    offset: The constant to use for the constraint.
     - returns:             A reference to self.
     */
    @discardableResult
    public func offset(_ offset: CGFloatRepresentable) -> NSLayoutConstraint {
        constant = offset.cgFloatValue
        return self
    }

    /**
     Updates the offset of the constraint. Identical to `offset(_:)`, but has no return value (for proper naming conventions, use this when actually updating a constraint, and use `offset(_:)` during constraint creation).
     - parameter    offset:  The constant to use for the constraint.
     */
    public func updateOffset(_ offset: CGFloatRepresentable) {
        self.offset(offset)
    }

    /**
     Sets the inset of the constraint and returns self.
     - parameter    inset:  For constraints in which the first anchor is the bottom, right, or trailing anchor, this creates a negative offset. Otherwise, acts identical to `offset(_:)`.
     - returns:             A reference to self.
     */
    @discardableResult
    public func inset(_ inset: CGFloatRepresentable) -> NSLayoutConstraint {
        switch firstAttribute {
        case .bottom, .right, .trailing, .lastBaseline:
            offset(-inset.cgFloatValue)
        default:
            #if os(iOS) || os(tvOS)
                switch firstAttribute {
                case .bottomMargin, .rightMargin, .trailingMargin:
                    offset(-inset.cgFloatValue)
                default:
                    offset(inset)
                }
            #else
                offset(inset)
            #endif
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
     Activates the constraints and returns self.
     - returns:     A reference to self.
     */
    @discardableResult
    public func activate() -> Self {
        forEach { $0.activate() }
        return self
    }

    /**
     Deactivates the constraints and returns self.
     - returns:     A reference to self.
     */
    @discardableResult
    public func deactivate() -> Self {
        forEach { $0.deactivate() }
        return self
    }

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
     Updates the offset of the constraints. Identical to `offset(_:)`, but has no return value (for proper naming conventions, use this when actually updating constraints, and use `offset(_:)` during constraint creation).
     - parameter    offset:  The constant to apply to each of the constraints.
     */
    public func updateOffsets(_ offset: CGFloatRepresentable) {
        self.offset(offset)
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

    /**
     Updates the insets of all constraints that correspond to left, right, top, or bottom sides of an item.
     - parameter    insets:  Creates insets on constraints that have a first anchor that corresponds to one of the insets, i.e. a constraint starting with a `leading` anchor will get an inset of `insets.left`.
     - returns:             A reference to self.
     */
    @discardableResult
    public func inset(_ insets: EdgeInsets) -> Self {
        filter { $0.firstAttribute.isLeftAttribute }.inset(insets.left)
        filter { $0.firstAttribute.isRightAttribute }.inset(insets.right)
        filter { $0.firstAttribute.isTopAttribute }.inset(insets.top)
        filter { $0.firstAttribute.isBottomAttribute }.inset(insets.bottom)
        return self
    }

    /**
     Updates the inset of all horizontal constraints and returns self.
     - parameter    inset:  For horizontal constraints in which the first anchor is the right or trailing anchor, this creates a negative offset. Otherwise, acts identical to `offset(_)`.
     - returns:             A reference to self.
     */
    @discardableResult
    public func insetHorizontal(_ inset: CGFloatRepresentable) -> Self {
        filter { $0.firstAttribute.isHorizontal }.forEach { $0.inset(inset) }
        return self
    }

    /**
     Updates the inset of all vertical constraints and returns self.
     - parameter    inset:  For vertical constraints in which the first anchor is the bottom anchor, this creates a negative offset. Otherwise, acts identical to `offset(_)`.
     - returns:             A reference to self.
     */
    @discardableResult
    public func insetVertical(_ inset: CGFloatRepresentable) -> Self {
        filter { $0.firstAttribute.isVertical }.forEach { $0.inset(inset) }
        return self
    }

    /**
     Updates the inset of all horizontal constraints. Identical to `insetHorizontal(_:)`, but has no return value (for proper naming conventions, use this when actually updating constraints, and use `insetHorizontal(_:)` during constraint creation).
     - parameter    inset:  For horizontal constraints in which the first anchor is the right or trailing anchor, this creates a negative offset. Otherwise, acts identical to `updateOffset(_)`.
     */
    public func updateHorizontalInsets(_ inset: CGFloatRepresentable) {
        insetHorizontal(inset)
    }

    /**
     Updates the inset of all vertical constraints. Identical to `insetVertical(_:)`, but has no return value (for proper naming conventions, use this when actually updating constraints, and use `insetVertical(_:)` during constraint creation).
     - parameter    inset:  For vertical constraints in which the first anchor is the bottom anchor, this creates a negative offset. Otherwise, acts identical to `updateOffset(_)`.
     */
    public func updateVerticalInsets(_ inset: CGFloatRepresentable) {
        insetVertical(inset)
    }

    /**
     Updates the inset of the constraints. Identical to `inset(_:)`, but has no return value (for proper naming conventions, use this when actually updating constraints, and use `inset(_:)` during constraint creation).
     - parameter    inset:  For constraints in which the first anchor is the bottom, right, or trailing anchor, this creates a negative offset. Otherwise, acts identical to `offset(_:)`.
     */
    public func updateInsets(_ inset: CGFloatRepresentable) {
        self.inset(inset)
    }

    /**
     Updates the insets of all constraints that correspond to left, right, top, or bottom sides of an item. Identical to `inset(_:)`, but has no return value (for proper naming conventions, use this when actually updating constraints, and use `inset(_:)` during constraint creation).
     - parameter    insets:  Creates insets on constraints that have a first anchor that corresponds to one of the insets, i.e. a constraint starting with a `leading` anchor will get an inset of `insets.left`.
     */
    public func updateInsets(_ insets: EdgeInsets) {
        self.inset(insets)
    }

    /**
     Updates any width and height constraints to the corresponding width and height of the provided size.
     - parameter    size:   The size to which to update the width and height constraints.
     */
    public func updateSize(_ size: CGSize) {
        filter { $0.firstAttribute == .width && $0.secondAttribute == .notAnAttribute }.updateOffsets(size.width)
        filter { $0.firstAttribute == .height && $0.secondAttribute == .notAnAttribute }.updateOffsets(size.height)
    }

}

// MARK: - Internal Helpers
extension LayoutAttribute {

    var isHorizontal: Bool {
        switch self {
        case .left, .right, .leading, .trailing, .centerX:
            return true
        default:
            #if os(iOS) || os(tvOS)
                switch self {
                case .centerXWithinMargins, .leftMargin, .leadingMargin, .rightMargin, .trailingMargin: return true
                default: break
                }
            #endif
            return false
        }
    }

    var isVertical: Bool {
        switch self {
        case .top, .bottom, .centerY, .firstBaseline, .lastBaseline:
            return true
        default:
            #if os(iOS) || os(tvOS)
                switch self {
                case .topMargin, .bottomMargin, .centerYWithinMargins: return true
                default: break
                }
            #endif
            return false
        }
    }

    var isLeftAttribute: Bool {
        switch self {
        case .left, .leading: return true
        default:
            #if os(iOS) || os(tvOS)
                switch self {
                case .leftMargin, .leadingMargin: return true
                default: break
                }
            #endif
            return false
        }
    }

    var isRightAttribute: Bool {
        switch self {
        case .right, .trailing: return true
        default:
            #if os(iOS) || os(tvOS)
                switch self {
                case .rightMargin, .trailingMargin: return true
                default: break
                }
            #endif
            return false
        }
    }

    var isTopAttribute: Bool {
        switch self {
        case .top: return true
        default:
            #if os(iOS) || os(tvOS)
                return self == .topMargin
            #else
                return false
            #endif
        }
    }

    var isBottomAttribute: Bool {
        switch self {
        case .bottom: return true
        default:
            #if os(iOS) || os(tvOS)
                return self == .bottomMargin
            #else
                return false
            #endif
        }
    }

}
