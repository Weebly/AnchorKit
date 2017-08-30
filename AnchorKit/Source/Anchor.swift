//
//  Anchor.swift
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

/**
 An enum representing layout anchors for a view or layout guide.
 */
public enum Anchor {

    /// A layout anchor representing the leading edge of the view’s frame.
    case leading

    /// A layout anchor representing the trailing edge of the view’s frame.
    case trailing

    /// A layout anchor representing the left edge of the view’s frame.
    case left

    /// A layout anchor representing the right edge of the view’s frame.
    case right

    /// A layout anchor representing the top edge of the view’s frame.
    case top

    /// A layout anchor representing the bottom edge of the view’s frame.
    case bottom

    /// A layout anchor representing the width of the view’s frame.
    case width

    /// A layout anchor representing the height of the view’s frame.
    case height

    /// A layout anchor representing the horizontal center of the view’s frame.
    case centerX

    /// A layout anchor representing the vertical center of the view’s frame.
    case centerY

    /// A layout anchor representing the baseline for the topmost line of text in the view. Not available for layout guides.
    case firstBaseline

    /// A layout anchor representing the baseline for the bottommost line of text in the view. Not available for layout guides.
    case lastBaseline

    // MARK: - Internal Helpers

    func layoutAnchor(for item: Anchorable) -> NSLayoutAnchor<AnyObject> {
        switch self {
        case .leading:
            return item.leadingAnchor as NSLayoutAnchor<NSLayoutXAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .trailing:
            return item.trailingAnchor as NSLayoutAnchor<NSLayoutXAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .left:
            return item.leftAnchor as NSLayoutAnchor<NSLayoutXAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .right:
            return item.rightAnchor as NSLayoutAnchor<NSLayoutXAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .top:
            return item.topAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .bottom:
            return item.bottomAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .width:
            return item.widthAnchor as NSLayoutAnchor<NSLayoutDimension> as! NSLayoutAnchor<AnyObject>
        case .height:
            return item.heightAnchor as NSLayoutAnchor<NSLayoutDimension> as! NSLayoutAnchor<AnyObject>
        case .centerX:
            return item.centerXAnchor as NSLayoutAnchor<NSLayoutXAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .centerY:
            return item.centerYAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .firstBaseline:
            guard let viewItem = item as? ViewAnchorable else {
                fatalError("The anchor \(self) is not available on the item \(item).")
            }
            return viewItem.firstBaselineAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .lastBaseline:
            guard let viewItem = item as? ViewAnchorable else {
                fatalError("The anchor \(self) is not available on the item \(item).")
            }
            return viewItem.lastBaselineAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        }
    }

    #if os(iOS) || os(tvOS)
    func layoutAnchor(for item: UILayoutSupport) -> NSLayoutAnchor<AnyObject> {
        switch self {
        case .top:
            return item.topAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .bottom:
            return item.bottomAnchor as NSLayoutAnchor<NSLayoutYAxisAnchor> as! NSLayoutAnchor<AnyObject>
        case .height:
            return item.heightAnchor as NSLayoutAnchor<NSLayoutDimension> as! NSLayoutAnchor<AnyObject>
        default:
            fatalError("The anchor \(self) is not available on the `UILayoutSupport` item \(item).")
        }
    }
    #endif

}
