//
//  Anchorable.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/19/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
    public typealias View = NSView
    public typealias LayoutGuide = NSLayoutGuide
#else
    import UIKit
    public typealias View = UIView
    public typealias LayoutGuide = UILayoutGuide
#endif

public protocol Anchorable {

    /// A layout anchor representing the leading edge of the view’s frame.
    var leadingAnchor: NSLayoutXAxisAnchor { get }

    /// A layout anchor representing the trailing edge of the view’s frame.
    var trailingAnchor: NSLayoutXAxisAnchor { get }

    /// A layout anchor representing the left edge of the view’s frame.
    var leftAnchor: NSLayoutXAxisAnchor { get }

    /// A layout anchor representing the right edge of the view’s frame.
    var rightAnchor: NSLayoutXAxisAnchor { get }

    /// A layout anchor representing the top edge of the view’s frame.
    var topAnchor: NSLayoutYAxisAnchor { get }

    /// A layout anchor representing the bottom edge of the view’s frame.
    var bottomAnchor: NSLayoutYAxisAnchor { get }

    /// A layout anchor representing the width of the view’s frame.
    var widthAnchor: NSLayoutDimension { get }

    /// A layout anchor representing the height of the view’s frame.
    var heightAnchor: NSLayoutDimension { get }

    /// A layout anchor representing the horizontal center of the view’s frame.
    var centerXAnchor: NSLayoutXAxisAnchor { get }

    /// A layout anchor representing the vertical center of the view’s frame.
    var centerYAnchor: NSLayoutYAxisAnchor { get }

    /// Runs any methods that might be necessary or convenient before adding constraints. Called every time a constraint is added.
    func prepareForConstraints()

    /// The view that owns this item. For layout guides, this returns `owningView`. For views, this returns the `superview`.
    var owningView: View? { get }
}

extension LayoutGuide: Anchorable { }

extension Anchorable {

    public func prepareForConstraints() { }

}

public protocol ViewAnchorable: Anchorable {

    /// A layout anchor representing the baseline for the topmost line of text in the view. Not available for layout guides.
    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }

    /// A layout anchor representing the baseline for the bottommost line of text in the view. Not available for layout guides.
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }

    /// Returns the constraints held by the view.
    var constraints: [NSLayoutConstraint] { get }
}

extension View: ViewAnchorable {

    /// Performs setup for constraints to be added. Sets `translatesAutoresizingMaskIntoConstraints` to `false`.
    public func prepareForConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// The `superview`.
    public var owningView: View? {
        return superview
    }

}
