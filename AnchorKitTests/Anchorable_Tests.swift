//
//  Anchorable_Tests.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/20/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

import XCTest
@testable import AnchorKit

class Anchorable_Tests: XCTestCase {

    var view1: View!
    var view2: View!
    var superview: View!

    #if os(iOS) || os(tvOS)
    var vc: UIViewController!
    var topLayoutGuide: UILayoutSupport {
        return vc.topLayoutGuide
    }
    #endif

    override func setUp() {
        super.setUp()
        view1 = View()
        view2 = View()
        superview = View()
        superview.addSubview(view1)
        superview.addSubview(view2)

        #if os(iOS) || os(tvOS)
        vc = UIViewController()
        vc.loadView()
        vc.view.addSubview(superview)
        #endif
    }

    override func tearDown() {
        view1 = nil
        view2 = nil
        superview = nil
        #if os(iOS) || os(tvOS)
        vc = nil
        #endif
        super.tearDown()
    }

    // MARK: - Owning View

    func testLayoutGuide_owningView() {
        let layoutGuide = LayoutGuide()
        view1.addLayoutGuide(layoutGuide)
        XCTAssertEqual((layoutGuide as Anchorable).owningView, view1)
    }

    func testView_owningView() {
        XCTAssertEqual(view1.owningView, superview)
    }

    // MARK: - Prepare for constraints

    func testMakeConstraint_twoAxisAnchors_preparesForConstraints() {
        _ = view1.constrainAnchor(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, priority: .required)
        XCTAssertFalse(view1.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view2.translatesAutoresizingMaskIntoConstraints)
    }

    func testMakeConstraint_twoDimensionAnchors_preparesForConstraints() {
        _ = view1.constrainDimension(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, multiplier: 1, priority: .required)
        XCTAssertFalse(view1.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(view2.translatesAutoresizingMaskIntoConstraints)
    }

    // MARK: - Activation

    func testMakeConstraint_twoAxisAnchors_isActive() {
        let equalConstraint = view1.constrainAnchor(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, priority: .required)
        let greaterConstraint = view1.constrainAnchor(view1.leadingAnchor, relation: .greaterThanOrEqual, to: view2.trailingAnchor, priority: .required)
        let lessConstraint = view1.constrainAnchor(view1.leadingAnchor, relation: .lessThanOrEqual, to: view2.trailingAnchor, priority: .required)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testMakeConstraint_twoDimensionAnchors_isActive() {
        let equalConstraint = view1.constrainDimension(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, multiplier: 1, priority: .required)
        let greaterConstraint = view1.constrainDimension(view1.widthAnchor, relation: .greaterThanOrEqual, to: view2.heightAnchor, multiplier: 1, priority: .required)
        let lessConstraint = view1.constrainDimension(view1.widthAnchor, relation: .lessThanOrEqual, to: view2.heightAnchor, multiplier: 1, priority: .required)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testMakeConstraint_dimensionAnchorToConstant_isActive() {
        let equalConstraint = view1.constrainDimension(view1.widthAnchor, relation: .equal, to: 10, priority: .required)
        let greaterConstraint = view1.constrainDimension(view1.widthAnchor, relation: .greaterThanOrEqual, to: 10, priority: .required)
        let lessConstraint = view1.constrainDimension(view1.widthAnchor, relation: .lessThanOrEqual, to: 10, priority: .required)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    // MARK: - Priority

    func testMakeConstraint_twoAxisAnchors_setsPriority() {
        let constraint = view1.constrainAnchor(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, priority: .high)
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 750)
        #else
            XCTAssertEqual(constraint.priority, 750)
        #endif
    }

    func testMakeConstraint_twoDimensionAnchors_setsPriority() {
        let constraint = view1.constrainDimension(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, multiplier: 1, priority: .low)
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 250)
        #else
            XCTAssertEqual(constraint.priority, 250)
        #endif
    }

    func testMakeConstraint_dimensionAnchorToConstant_setsPriority() {
        let constraint = view1.constrainDimension(view1.widthAnchor, relation: .equal, to: 10, priority: .custom(420))
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 420)
        #else
            XCTAssertEqual(constraint.priority, 420)
        #endif
    }

    // MARK: - Anchor to constant

    func testConstrainWidthToConstant() {
        let constraint = view1.constrain(.width, relation: .greaterThanOrEqual, toConstant: 20, priority: .medium)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.widthAnchor)
        XCTAssertNil(constraint.secondAnchor)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 500)
        #else
            XCTAssertEqual(constraint.priority, 500)
        #endif
    }

    func testConstrainHeightToConstant() {
        let constraint = view1.constrain(.height, toConstant: 20)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.heightAnchor)
        XCTAssertNil(constraint.secondAnchor)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainLeadingToConstant_view() {
        let constraint = view1.constrain(.leading, toConstant: 20)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, superview.leadingAnchor)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainLeadingToConstant_layoutGuide() {
        let layoutGuide = LayoutGuide()
        view1.addLayoutGuide(layoutGuide)
        let constraint = layoutGuide.constrain(.leading, toConstant: 20)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, layoutGuide.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainWidthToConstant_lessThanOrEqual() {
        let constraint = view1.constrain(.width, relation: .lessThanOrEqual, toConstant: 20)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }

    func testConstrainHeightToConstant_greaterThanOrEqual() {
        let constraint = view1.constrain(.height, relation: .greaterThanOrEqual, toConstant: 20)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func testConstraintTrailingToConstant_greaterThanOrEqual() {
        let constraint = view1.constrain(.width, relation: .greaterThanOrEqual, toConstant: 20)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func testConstrainAnchorToConstant_defaults() {
        let constraint = view1.constrain(.width, toConstant: 40)
        testDefaults(for: constraint, constant: 40)
    }

    func testConstrainMultipleAnchorsToConstant() {
        let constraints = view1.constrain(.width, .height, .top, toConstant: 20)
        XCTAssertEqual(constraints.map { $0.constant }, [20, 20, 20])
        XCTAssertEqual(constraints[0].firstAnchor, view1.widthAnchor)
        XCTAssertEqual(constraints[1].firstAnchor, view1.heightAnchor)
        XCTAssertEqual(constraints[2].firstAnchor, view1.topAnchor)
        XCTAssertNil(constraints[0].secondAnchor)
        XCTAssertNil(constraints[1].secondAnchor)
        XCTAssertEqual(constraints[2].secondAnchor, superview.topAnchor)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.equal])
    }

    func testConstrainMultipleAnchorsToConstant_lessThanOrEqual() {
        let constraints = view1.constrain(.width, .height, .top, relation: .lessThanOrEqual, toConstant: 20)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.lessThanOrEqual])
    }

    func testConstrainMultipleAnchorsToConstant_defaults() {
        let constraints = view1.constrain(.width, .height, .top, toConstant: 20)
        constraints.forEach { testDefaults(for: $0, constant: 20) }
    }

    // MARK: - Anchor to item

    func testConstrainAnchorToItem() {
        let constraint = view1.constrain(.height, to: view2, multiplier: 2, priority: .medium).offset(20)
        XCTAssertEqual(constraint.firstAnchor, view1.heightAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.heightAnchor)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.multiplier, 2)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainMultipleAnchorsToItem() {
        let constraints = view1.constrain(.bottom, .width, to: view2, multiplier: 3).offset(20)
        XCTAssertEqual(constraints[0].firstAnchor, view1.bottomAnchor)
        XCTAssertEqual(constraints[0].secondAnchor, view2.bottomAnchor)
        XCTAssertEqual(constraints[1].firstAnchor, view1.widthAnchor)
        XCTAssertEqual(constraints[1].secondAnchor, view2.widthAnchor)
        XCTAssertEqual(constraints[0].constant, 20)
        XCTAssertEqual(constraints[1].constant, 20)
        XCTAssertEqual(constraints[1].multiplier, 3)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.equal])
    }

    func testConstrainAnchorToItem_lessThanOrEqual() {
        let constraint = view1.constrain(.bottom, relation: .lessThanOrEqual, to: view2)
        XCTAssertEqual(constraint.firstAnchor, view1.bottomAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.bottomAnchor)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }

    func testConstrainAnchorToItem_defaults() {
        let constraint = view1.constrain(.bottom, to: view2)
        testDefaults(for: constraint)
    }

    // MARK: - Edges

    func testConstrainEdgesToItem() {
        let constraints = view1.constrainEdges(to: view2).inset(7)
        XCTAssertEqual(constraints.map { $0.constant }, [7, -7, 7, -7])
        XCTAssertEqual(constraints.count, 4)
        let expectedFirstAnchors = [view1.leadingAnchor, view1.trailingAnchor, view1.topAnchor, view1.bottomAnchor]
        XCTAssertEqual(constraints.compactMap { $0.firstAnchor }, expectedFirstAnchors)
        let expectedSecondAnchors = [view2.leadingAnchor, view2.trailingAnchor, view2.topAnchor, view2.bottomAnchor]
        XCTAssertEqual(constraints.compactMap { $0.secondAnchor }, expectedSecondAnchors)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.equal])
    }

    func testConstrainEdgesToItem_greaterThanOrEqual() {
        let constraints = view1.constrainEdges(.greaterThanOrEqual, to: view2)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.greaterThanOrEqual])
    }

    func testConstrainEdgesToItem_defaults() {
        let constraints = view1.constrainEdges(to: view2)
        constraints.forEach { testDefaults(for: $0) }
    }

    // MARK: - Center

    func testConstrainCenterToItem_defaults() {
        let constraints = view1.constrainCenter(to: view2)
        constraints.forEach { testDefaults(for: $0) }
    }

    func testConstrainCenterToItem() {
        let constraints = view1.constrainCenter(to: view2, priority: .high).offset(10)
        XCTAssertEqual(constraints.map { $0.constant }, [10, 10])
        XCTAssertEqual(constraints.count, 2)
        XCTAssertEqual(constraints.compactMap { $0.firstAnchor }, [view1.centerXAnchor, view1.centerYAnchor])
        XCTAssertEqual(constraints.compactMap { $0.secondAnchor }, [view2.centerXAnchor, view2.centerYAnchor])
        XCTAssertEqual(constraints.map { $0.layoutPriority }, [.high, .high])
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.equal])
    }

    func testConstrainCenterToItem_greaterThanOrEqual() {
        let constraints = view1.constrainCenter(.greaterThanOrEqual, to: view2)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.greaterThanOrEqual])
    }

    // MARK: - Anchor to anchor

    func testConstrainTwoAxisAnchors() {
        let constraint = view1.constrain(.leading, to: .trailing, of: view2).offset(4)
        XCTAssertEqual(constraint.firstAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.trailingAnchor)
        XCTAssertEqual(constraint.constant, 4)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainTwoDimensionAnchors() {
        let constraint = view1.constrain(.width, relation: .greaterThanOrEqual, to: .height, of: view2, multiplier: 5).offset(2)
        XCTAssertEqual(constraint.firstAnchor, view1.widthAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.heightAnchor)
        XCTAssertEqual(constraint.multiplier, 5)
        XCTAssertEqual(constraint.constant, 2)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func testConstrainViewAnchorToLayoutGuideAnchor() {
        let layoutGuide = LayoutGuide()
        view2.addLayoutGuide(layoutGuide)
        let constraint = view1.constrain(.leading, to: .trailing, of: layoutGuide).offset(2)
        XCTAssertEqual(constraint.firstAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, layoutGuide.trailingAnchor)
        XCTAssertEqual(constraint.constant, 2)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainTwoAnchors_defaults() {
        let constraint = view1.constrain(.leading, to: .trailing, of: view2)
        testDefaults(for: constraint)
    }

    // MARK: - Size

    func testConstrainToSize() {
        let constraints = view1.constrain(to: CGSize(width: 20, height: 30), priority: .medium)
        XCTAssertEqual(constraints[0].firstAnchor, view1.widthAnchor)
        XCTAssertEqual(constraints[0].constant, 20)
        XCTAssertEqual(constraints[1].firstAnchor, view1.heightAnchor)
        XCTAssertEqual(constraints[1].constant, 30)
    }

    func testConstrainToSize_lessThanOrEqual() {
        let constraints = view1.constrain(.lessThanOrEqual, to: CGSize(width: 20, height: 30), priority: .medium)
        XCTAssertEqual(constraints[0].relation, .lessThanOrEqual)
        XCTAssertEqual(constraints[1].relation, .lessThanOrEqual)
    }

    func testConstrainToSize_defaults() {
        let constraint = view1.constrain(to: CGSize(width: 30, height: 30))
        constraint.forEach { testDefaults(for: $0, constant: 30) }
    }

    func testUpdateSize() {
        let sizeConstraints = view1.constrain(to: CGSize(width: 40, height: 100))
        let leadingConstraint = view1.constrain(.leading, to: view2).offset(-17)
        view1.updateSize(CGSize(width: 200, height: 300))
        XCTAssertEqual(sizeConstraints, view1.constraints)
        XCTAssertEqual(sizeConstraints[0].constant, 200)
        XCTAssertEqual(sizeConstraints[1].constant, 300)
        XCTAssertEqual(leadingConstraint.constant, -17)
    }

    // MARK: - Width and Height

    func testUpdateWidth() {
        let constraints = view1.constrain(.width, .height, toConstant: 100)
        view1.updateWidth(200)
        XCTAssertEqual(constraints[0].constant, 200)
        XCTAssertEqual(constraints[1].constant, 100)
    }

    func testUpdateHeight() {
        let constraints = view1.constrain(.width, .height, toConstant: 100)
        view1.updateHeight(200)
        XCTAssertEqual(constraints[0].constant, 100)
        XCTAssertEqual(constraints[1].constant, 200)
    }

    #if os(iOS) || os(tvOS)

    // MARK: - UILayoutSupport

    func testConstrainAnchorToAnchorOfUILayoutSupportItem() {
        let constraint = view1.constrain(.top, to: .bottom, of: topLayoutGuide).offset(20)
        XCTAssertEqual(constraint.firstAnchor, view1.topAnchor)
        XCTAssertEqual(constraint.secondAnchor, topLayoutGuide.bottomAnchor)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.multiplier, 1)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainAnchorToUILayoutSupportItem() {
        let constraint = view1.constrain(.height, to: topLayoutGuide, multiplier: 2, priority: .medium).offset(20)
        XCTAssertEqual(constraint.firstAnchor, view1.heightAnchor)
        XCTAssertEqual(constraint.secondAnchor, topLayoutGuide.heightAnchor)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.multiplier, 2)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainMultipleAnchorsToUILayoutSupportItem() {
        let constraints = view1.constrain(.bottom, .height, to: topLayoutGuide, multiplier: 3).offset(20)
        XCTAssertEqual(constraints[0].firstAnchor, view1.bottomAnchor)
        XCTAssertEqual(constraints[0].secondAnchor, topLayoutGuide.bottomAnchor)
        XCTAssertEqual(constraints[1].firstAnchor, view1.heightAnchor)
        XCTAssertEqual(constraints[1].secondAnchor, topLayoutGuide.heightAnchor)
        XCTAssertEqual(constraints[0].constant, 20)
        XCTAssertEqual(constraints[1].constant, 20)
        XCTAssertEqual(constraints[1].multiplier, 3)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.equal])
    }

    func testConstrainAnchorToUILayoutSupportItem_lessThanOrEqual() {
        let constraint = view1.constrain(.bottom, relation: .lessThanOrEqual, to: topLayoutGuide)
        XCTAssertEqual(constraint.firstAnchor, view1.bottomAnchor)
        XCTAssertEqual(constraint.secondAnchor, topLayoutGuide.bottomAnchor)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }

    func testConstrainAnchorToUILayoutSupportItem_defaults() {
        let constraint = view1.constrain(.bottom, to: topLayoutGuide)
        testDefaults(for: constraint)
    }

    #if swift(>=3.2)

    // MARK: - System Spacing Constraints

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_defaults() {
        let constraint = view1.constrainUsingSystemSpacing(.top, .below, .bottom, of: view2)
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 1000)
        #else
            XCTAssertEqual(constraint.priority, 1000)
        #endif
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.multiplier, 1)
        XCTAssert(constraint.isActive)
        XCTAssertGreaterThan(constraint.constant, 0)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_after_greaterThanOrEqual() {
        let constraint = view1.constrainUsingSystemSpacing(.leading, relation: .greaterThanOrEqual, .after, .trailing, of: view2.safeAreaLayoutGuide)
        XCTAssertGreaterThan(constraint.constant, 0)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_after_lessThanOrEqual() {
        let constraint = view1.constrainUsingSystemSpacing(.leading, relation: .lessThanOrEqual, .after, .leading, of: view2.safeAreaLayoutGuide)
        XCTAssertGreaterThan(constraint.constant, 0)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_below_greaterThanOrEqual() {
        let constraint = view1.constrainUsingSystemSpacing(.top, relation: .greaterThanOrEqual, .below, .bottom, of: view2.safeAreaLayoutGuide)
        XCTAssertGreaterThan(constraint.constant, 0)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_below_lessThanOrEqual() {
        let constraint = view1.constrainUsingSystemSpacing(.top, relation: .lessThanOrEqual, .below, .bottom, of: view2.safeAreaLayoutGuide)
        XCTAssertGreaterThan(constraint.constant, 0)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_multiplier() {
        // let constraint = view1.constrainUsingSystemSpacing(.leading, .after, .trailing, of: view2.safeAreaLayoutGuide, multiplier: 2.3)
        // FIXME: for some reason the multiplier always changes back to 1, could be a bug in iOS 11
        // XCTAssertEqual(constraint.multiplier, 2.3)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing_priority() {
        let constraint = view1.constrainUsingSystemSpacing(.top, .below, .bottom, of: view2.safeAreaLayoutGuide, priority: .low)
        XCTAssertEqual(constraint.layoutPriority, .low)
    }

    @available(iOS 11, tvOS 11, *)
    func testConstrainUsingSystemSpacing() {
        let constraint = view1.constrainUsingSystemSpacing(.top, .below, .bottom, of: view2.safeAreaLayoutGuide)
        XCTAssertEqual(constraint.firstAnchor, view1.topAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.safeAreaLayoutGuide.bottomAnchor)
    }

    #endif

    #endif

    // MARK: - Helpers

    func testDefaults(for constraint: NSLayoutConstraint, constant: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(constraint.constant, constant, file: file, line: line)
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 1000, file: file, line: line)
        #else
            XCTAssertEqual(constraint.priority, 1000, file: file, line: line)
        #endif
        XCTAssertEqual(constraint.relation, .equal, file: file, line: line)
        XCTAssertEqual(constraint.multiplier, 1, file: file, line: line)
        XCTAssert(constraint.isActive, file: file, line: line)
    }

}
