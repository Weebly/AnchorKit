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
    public func constrain<AnchorableType: Anchorable>(_ anchor: Anchor, relation: NSLayoutRelation = .equal, to otherAnchor: Anchor, of item: AnchorableType, multiplier: CGFloatRepresentable = 1, constant: CGFloatRepresentable = 0, priority: LayoutPriority = .required) -> NSLayoutConstraint {
        let firstAnchor = anchor.layoutAnchor(for: self)
        let secondAnchor = otherAnchor.layoutAnchor(for: item)

        if let firstDimension = firstAnchor as? NSLayoutAnchor<NSLayoutDimension> as? NSLayoutDimension,
            let secondDimension = secondAnchor as? NSLayoutAnchor<NSLayoutDimension> as? NSLayoutDimension {
            return makeConstraint(firstDimension, relation: relation, to: secondDimension, multiplier: multiplier, constant: constant, priority: priority)
        } else {
            return makeConstraint(firstAnchor, relation: relation, to: secondAnchor, constant: constant, priority: priority)
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
    public func constrain<AnchorableType: Anchorable>(_ anchor: Anchor, relation: NSLayoutRelation = .equal, to item: AnchorableType, multiplier: CGFloatRepresentable = 1, constant: CGFloatRepresentable = 0, priority: LayoutPriority = .required) -> NSLayoutConstraint {
        return constrain(anchor, relation: relation, to: anchor, of: item, multiplier: multiplier, constant: constant, priority: priority)
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
    public func constrain<AnchorableType: Anchorable>(_ anchors: Anchor..., relation: NSLayoutRelation = .equal, to item: AnchorableType, multiplier: CGFloatRepresentable = 1, constant: CGFloatRepresentable = 0, priority: LayoutPriority = .required) -> [NSLayoutConstraint] {
        return anchors.map { constrain($0, relation: relation, to: item, multiplier: multiplier, constant: constant, priority: priority) }
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
    public func constrain(_ anchor: Anchor, relation: NSLayoutRelation = .equal, toConstant constant: CGFloatRepresentable, priority: LayoutPriority = .required) -> NSLayoutConstraint {
        switch anchor {
        case .width: return makeConstraint(widthAnchor, relation: relation, to: constant, priority: priority)
        case .height: return makeConstraint(heightAnchor, relation: relation, to: constant, priority: priority)
        default:
            /**
             At this point, we're trying to setup a constraint with a non-dimensional anchor with only a constant.
             We assume that the constraint should be related to the view's superview. If the item is a layout guide
             or if the item is a view without a superview, we crash.
            */
            guard let superview = (self as? View)?.superview else {
                fatalError("Attempting to constrain a \(anchor) anchor using only a constant to a view that has no superview. Please ensure that a superview first exists, or use constrain(:relation:to:multiplier:constant).")
            }
            return constrain(anchor, relation: relation, to: superview, constant: constant, priority: priority)
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
    public func constrain(_ anchors: Anchor..., relation: NSLayoutRelation = .equal, toConstant constant: CGFloatRepresentable, priority: LayoutPriority = .required) -> [NSLayoutConstraint] {
        return anchors.map { constrain($0, relation: relation, toConstant: constant, priority: priority) }
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
    public func constrainEdges<AnchorableType: Anchorable>(_ relation: NSLayoutRelation, to item: AnchorableType, inset: CGFloatRepresentable = 0, priority: LayoutPriority = .required) -> [NSLayoutConstraint] {
        let cgInset = inset.cgFloatValue
        return [
            constrain(.leading, relation: relation, to: item, constant: cgInset, priority: priority),
            constrain(.trailing, relation: relation, to: item, constant: -cgInset.cgFloatValue, priority: priority),
            constrain(.top, relation: relation, to: item, constant: cgInset, priority: priority),
            constrain(.bottom, relation: relation, to: item, constant: -cgInset, priority: priority)
        ]
    }

    /**
     Constrains the edges of the current item to another item by creating and activating the leading, trailing, top, and bottom constraints. If you want to use this with a relation, use `constrainEdges(_:to:inset)`.
     - parameter    item:       The item to which to constrain.
     - parameter    inset:      The inset to apply to the edges. A positive inset will make the entire view smaller than the `item`. Default is 0.
     - returns:                 The newly created and activated constraints for the leading, trailing, top, and bottom anchors.
     */
    @discardableResult
    public func constrainEdges<AnchorableType: Anchorable>(to item: AnchorableType, inset: CGFloatRepresentable = 0, priority: LayoutPriority = .required) -> [NSLayoutConstraint] {
        return constrainEdges(.equal, to: item, inset: inset, priority: priority)
    }

    // MARK: - Helpers

    func makeConstraint<ObjectType: AnyObject>(_ anchor: NSLayoutAnchor<ObjectType>, relation: NSLayoutRelation, to otherAnchor: NSLayoutAnchor<ObjectType>, constant: CGFloatRepresentable, priority: LayoutPriority) -> NSLayoutConstraint {
        prepareForConstraints()

        let constraint: NSLayoutConstraint
        switch relation {
        case .equal: constraint = anchor.constraint(equalTo: otherAnchor, constant: constant.cgFloatValue)
        case .greaterThanOrEqual: constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant.cgFloatValue)
        case .lessThanOrEqual: constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant.cgFloatValue)
        }

        constraint.layoutPriority = priority
        return constraint.activate()
    }

    func makeConstraint(_ dimension: NSLayoutDimension, relation: NSLayoutRelation, to otherDimension: NSLayoutDimension, multiplier: CGFloatRepresentable, constant: CGFloatRepresentable, priority: LayoutPriority) -> NSLayoutConstraint {
        prepareForConstraints()

        let constraint: NSLayoutConstraint
        switch relation {
        case .equal: constraint = dimension.constraint(equalTo: otherDimension, multiplier: multiplier.cgFloatValue, constant: constant.cgFloatValue)
        case .greaterThanOrEqual: constraint = dimension.constraint(greaterThanOrEqualTo: otherDimension, multiplier: multiplier.cgFloatValue, constant: constant.cgFloatValue)
        case .lessThanOrEqual: constraint = dimension.constraint(lessThanOrEqualTo: otherDimension, multiplier: multiplier.cgFloatValue, constant: constant.cgFloatValue)
        }

        constraint.layoutPriority = priority
        return constraint.activate()
    }

    func makeConstraint(_ dimension: NSLayoutDimension, relation: NSLayoutRelation, to constant: CGFloatRepresentable, priority: LayoutPriority) -> NSLayoutConstraint {
        prepareForConstraints()

        let constraint: NSLayoutConstraint
        switch relation {
        case .equal: constraint = dimension.constraint(equalToConstant: constant.cgFloatValue)
        case .greaterThanOrEqual: constraint = dimension.constraint(greaterThanOrEqualToConstant: constant.cgFloatValue)
        case .lessThanOrEqual: constraint = dimension.constraint(lessThanOrEqualToConstant: constant.cgFloatValue)
        }

        constraint.layoutPriority = priority
        return constraint.activate()
    }
    
}
