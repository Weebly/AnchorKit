//
//  Anchorable+Constraints.swift
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

extension Anchorable {

    /**
     Creates and activates a constraint from one anchor to another.
     - parameter    anchor:         The first anchor in the constraint.
     - parameter    relation:       The relation between the two anchors. Default is `equal`.
     - parameter    otherAnchor:    The second anchor in the constraint. Must be of the same type as the first anchor (e.g. cannot pair up `.leading` and `.bottom` because the first is an x-axis constraint while the second is a y-axis constraint).
     - parameter    item:           The item that to which the second anchor belongs.
     - parameter    multiplier:     The multiplier for the constraint. Only applies to dimensional anchors (width and height). Default is 1.
     - parameter    constant:       The constant/offset in the constraint. Default is 0.
     - returns:                     The newly created and activated constraint.
     */
    @discardableResult
    public func constrain<AnchorableType: Anchorable>(_ anchor: Anchor, relation: NSLayoutRelation = .equal, to otherAnchor: Anchor, of item: AnchorableType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        let firstAnchor = anchor.layoutAnchor(for: self)
        let secondAnchor = otherAnchor.layoutAnchor(for: item)

        if let firstDimension = firstAnchor as? NSLayoutAnchor<NSLayoutDimension> as? NSLayoutDimension,
            let secondDimension = secondAnchor as? NSLayoutAnchor<NSLayoutDimension> as? NSLayoutDimension {
            return constrain(firstDimension, relation: relation, to: secondDimension, multiplier: multiplier, constant: constant)
        } else {
            return constrain(firstAnchor, relation: relation, to: secondAnchor, constant: constant)
        }
    }

    /**
     Creates and activates a constraint between an anchor and the corresponding anchor on another item.
     - parameter    anchor:     The first anchor in the constraint.
     - parameter    relation:   The relation between the two anchors. Default is `equal`.
     - parameter    item:       The item to which to constrain.
     - parameter    multiplier: The multiplier for the constraint. Only applies to dimensional anchors (width and height). Default is 1.
     - parameter    constant:   The constant/offset in the constraint. Default is 0.
     - returns:                 The newly created and activated constraint.
     */
    @discardableResult
    public func constrain<AnchorableType: Anchorable>(_ anchor: Anchor, relation: NSLayoutRelation = .equal, to item: AnchorableType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        return constrain(anchor, relation: relation, to: anchor, of: item, multiplier: multiplier, constant: constant)
    }

    /**
     Creates and activates one or more constraints between anchors and their corresponding anchors on another item.
     - parameter    anchors:    The first anchors in the constraints.
     - parameter    relation:   The relation between all the pairs of anchors. Default is `equal`.
     - parameter    item:       The item to which to constrain.
     - parameter    multiplier: The multiplier for the constraints. Only applies to dimensional anchors (width and height). Default is 1.
     - parameter    constant:   The constant/offset in all the constraints. Default is 0.
     - returns:                 The newly created and activated constraints.
     */
    @discardableResult
    public func constrain<AnchorableType: Anchorable>(_ anchors: Anchor..., relation: NSLayoutRelation = .equal, to item: AnchorableType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return anchors.map { constrain($0, relation: relation, to: item, multiplier: multiplier, constant: constant) }
    }

    /**
     Creates and activates a constraint between an anchor and a constant. This behaves as expected with width and height anchors. 
     For all other anchors, if the item is a view, a constraint will be created between the view and it's superview at the 
     corresponding anchor, offset by `constant`. For layout guides, only width and height anchors will work.
     - parameter    anchor:     The anchor in the constraint.
     - parameter    relation:   The relation between the anchor and the constant. Default is `equal`.
     - parameter    constant:   The constant/offset in the constraint. Default is 0.
     - returns:                 The newly created and activated constraint.
     */
    @discardableResult
    public func constrain(_ anchor: Anchor, relation: NSLayoutRelation = .equal, toConstant constant: CGFloat) -> NSLayoutConstraint {
        switch anchor {
        case .width: return constrain(widthAnchor, relation: relation, to: constant)
        case .height: return constrain(heightAnchor, relation: relation, to: constant)
        default:
            /**
             At this point, we're trying to setup a constraint with a non-dimensional anchor with only a constant.
             We assume that the constraint should be related to the view's superview. If the item is a layout guide
             or if the item is a view without a superview, we crash.
            */
            guard let superview = (self as? View)?.superview else {
                fatalError("Attempting to constrain a \(anchor) anchor using only a constant to a view that has no superview. Please ensure that a superview first exists, or use constrain(anchor:_:to:multiplier:constant).")
            }
            return constrain(anchor, relation: relation, to: superview, constant: constant)
        }
    }

    /**
     Creates and activates one or more constraints between anchors and a constant.
     - parameter    anchors:    The anchors in the constraints.
     - parameter    relation:   The relation between the anchors and the constant. Default is `equal`.
     - parameter    constant:   The constant/offset for each constraint. Default is 0.
     - returns:                 The newly created and activated constraints.
     */
    @discardableResult
    public func constrain(_ anchors: Anchor..., relation: NSLayoutRelation = .equal, toConstant constant: CGFloat) -> [NSLayoutConstraint] {
        return anchors.map { constrain($0, relation: relation, toConstant: constant) }
    }

    // MARK: - Edge Constraints

    /**
     Constrains the edges of the current item to another item by creating and activating the leading, trailing, top, and bottom constraints.
     - parameter    relation:   The relation for all of the constraints. If you want to use `.equal`, you can use `constrainEdges(to:inset:)` instead.
     - parameter    item:       The item to which to constrain.
     - parameter    inset:      The inset to apply to the edges. A positive inset will make the entire view smaller than the `item`. Default is 0.
     - returns:                 The newly created and activated constraints for the leading, trailing, top, and bottom anchors.
     */
    @discardableResult
    public func constrainEdges<AnchorableType: Anchorable>(_ relation: NSLayoutRelation, to item: AnchorableType, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            constrain(.leading, relation: relation, to: item, constant: inset),
            constrain(.trailing, relation: relation, to: item, constant: -inset),
            constrain(.top, relation: relation, to: item, constant: inset),
            constrain(.bottom, relation: relation, to: item, constant: -inset)
        ]
    }

    /**
     Constrains the edges of the current item to another item by creating and activating the leading, trailing, top, and bottom constraints. If you want to use this with a relation, use `constrainEdges(_:to:inset)`.
     - parameter    item:       The item to which to constrain.
     - parameter    inset:      The inset to apply to the edges. A positive inset will make the entire view smaller than the `item`. Default is 0.
     - returns:                 The newly created and activated constraints for the leading, trailing, top, and bottom anchors.
     */
    @discardableResult
    public func constrainEdges<AnchorableType: Anchorable>(to item: AnchorableType, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return constrainEdges(.equal, to: item, inset: inset)
    }

    // MARK: - Helpers

    func constrain<ObjectType: AnyObject>(_ anchor: NSLayoutAnchor<ObjectType>, relation: NSLayoutRelation, to otherAnchor: NSLayoutAnchor<ObjectType>, constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        switch relation {
        case .equal: return anchor.constraint(equalTo: otherAnchor, constant: constant).activate()
        case .greaterThanOrEqual: return anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant).activate()
        case .lessThanOrEqual: return anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant).activate()
        }
    }

    func constrain(_ dimension: NSLayoutDimension, relation: NSLayoutRelation, to otherDimension: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        switch relation {
        case .equal: return dimension.constraint(equalTo: otherDimension, multiplier: multiplier, constant: constant).activate()
        case .greaterThanOrEqual: return dimension.constraint(greaterThanOrEqualTo: otherDimension, multiplier: multiplier, constant: constant).activate()
        case .lessThanOrEqual: return dimension.constraint(lessThanOrEqualTo: otherDimension, multiplier: multiplier, constant: constant).activate()
        }
    }

    func constrain(_ dimension: NSLayoutDimension, relation: NSLayoutRelation, to constant: CGFloat) -> NSLayoutConstraint {
        prepareForConstraints()
        switch relation {
        case .equal: return dimension.constraint(equalToConstant: constant).activate()
        case .greaterThanOrEqual: return dimension.constraint(greaterThanOrEqualToConstant: constant).activate()
        case .lessThanOrEqual: return dimension.constraint(lessThanOrEqualToConstant: constant).activate()
        }
    }
    
}
