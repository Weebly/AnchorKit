//
//  Anchorable_Tests.swift
//  Anchor
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
@testable import Anchor

class Anchorable_Tests: XCTestCase {

    var view1: View!
    var view2: View!
    var superview: View!

    override func setUp() {
        super.setUp()
        view1 = View()
        view2 = View()
        superview = View()
        superview.addSubview(view1)
        superview.addSubview(view2)
    }

    override func tearDown() {
        view1 = nil
        view2 = nil
        superview = nil
        super.tearDown()
    }

    // MARK: - Prepare for constraints

    func testMakeConstraint_twoAxisAnchors_preparesForConstraints() {
        _ = view1.makeConstraint(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, of: view2, constant: 0, priority: .required)
        XCTAssertFalse(view1.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(view2.translatesAutoresizingMaskIntoConstraints)
    }

    func testMakeConstraint_twoDimensionAnchors_preparesForConstraints() {
        _ = view1.makeConstraint(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, of: view2, multiplier: 1, constant: 0, priority: .required)
        XCTAssertFalse(view1.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(view2.translatesAutoresizingMaskIntoConstraints)
    }

    // MARK: - Activation

    func testMakeConstraint_twoAxisAnchors_isActive() {
        let equalConstraint = view1.makeConstraint(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, of: view2, constant: 0, priority: .required)
        let greaterConstraint = view1.makeConstraint(view1.leadingAnchor, relation: .greaterThanOrEqual, to: view2.trailingAnchor, of: view2, constant: 0, priority: .required)
        let lessConstraint = view1.makeConstraint(view1.leadingAnchor, relation: .lessThanOrEqual, to: view2.trailingAnchor, of: view2, constant: 0, priority: .required)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testMakeConstraint_twoDimensionAnchors_isActive() {
        let equalConstraint = view1.makeConstraint(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, of: view2, multiplier: 1, constant: 0, priority: .required)
        let greaterConstraint = view1.makeConstraint(view1.widthAnchor, relation: .greaterThanOrEqual, to: view2.heightAnchor, of: view2, multiplier: 1, constant: 0, priority: .required)
        let lessConstraint = view1.makeConstraint(view1.widthAnchor, relation: .lessThanOrEqual, to: view2.heightAnchor, of: view2, multiplier: 1, constant: 0, priority: .required)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testMakeConstraint_dimensionAnchorToConstant_isActive() {
        let equalConstraint = view1.makeConstraint(view1.widthAnchor, relation: .equal, to: 10, priority: .required)
        let greaterConstraint = view1.makeConstraint(view1.widthAnchor, relation: .greaterThanOrEqual, to: 10, priority: .required)
        let lessConstraint = view1.makeConstraint(view1.widthAnchor, relation: .lessThanOrEqual, to: 10, priority: .required)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testMakeConstraint_twoAxisAnchors_setsPriority() {
        let constraint = view1.makeConstraint(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, of: view2, constant: 0, priority: .high)
        XCTAssertEqual(constraint.priority, 750)
    }

    func testMakeConstraint_twoDimensionAnchors_setsPriority() {
        let constraint = view1.makeConstraint(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, of: view2, multiplier: 1, constant: 0, priority: .low)
        XCTAssertEqual(constraint.priority, 250)
    }

    func testMakeConstraint_dimensionAnchorToConstant_setsPriority() {
        let constraint = view1.makeConstraint(view1.widthAnchor, relation: .equal, to: 10, priority: .custom(420))
        XCTAssertEqual(constraint.priority, 420)
    }

    // MARK: - Anchor to constant

    func testConstrainWidthToConstant() {
        let constraint = view1.constrain(.width, relation: .greaterThanOrEqual, toConstant: 20, priority: .medium)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.widthAnchor)
        XCTAssertNil(constraint.secondAnchor)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.priority, 500)
    }

    func testConstrainHeightToConstant() {
        let constraint = view1.constrain(.height, toConstant: 20)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.heightAnchor)
        XCTAssertNil(constraint.secondAnchor)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainLeadingToConstant() {
        let constraint = view1.constrain(.leading, toConstant: 20)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, superview.leadingAnchor)
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

    func testCosntrainMultipleAnchorsToConstant_defaults() {
        let constraints = view1.constrain(.width, .height, .top, toConstant: 20)
        constraints.forEach { testDefaults(for: $0, constant: 20) }
    }

    // MARK: - Anchor to item

    func testConstrainAnchorToItem() {
        let constraint = view1.constrain(.height, to: view2, multiplier: 2, constant: 20, priority: .medium)
        XCTAssertEqual(constraint.firstAnchor, view1.heightAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.heightAnchor)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.multiplier, 2)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainMultipleAnchorsToItem() {
        let constraints = view1.constrain(.bottom, .width, to: view2, multiplier: 3, constant: 20)
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
        let constraints = view1.constrainEdges(to: view2, inset: 7)
        XCTAssertEqual(constraints.map { $0.constant }, [7, -7, 7, -7])
        XCTAssertEqual(constraints.count, 4)
        let expectedFirstAnchors = [view1.leadingAnchor, view1.trailingAnchor, view1.topAnchor, view1.bottomAnchor]
        XCTAssertEqual(constraints.flatMap { $0.firstAnchor }, expectedFirstAnchors)
        let expectedSecondAnchors = [view2.leadingAnchor, view2.trailingAnchor, view2.topAnchor, view2.bottomAnchor]
        XCTAssertEqual(constraints.flatMap { $0.secondAnchor }, expectedSecondAnchors)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.equal])
    }

    func testConstrainEdgesToItem_greaterThanOrEqual() {
        let constraints = view1.constrainEdges(.greaterThanOrEqual, to: view2, inset: 7)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.greaterThanOrEqual,])
    }

    func testConstrainEdgesToItem_defaults() {
        let constraints = view1.constrainEdges(to: view2)
        constraints.forEach { testDefaults(for: $0) }
    }

    // MARK: - Anchor to anchor

    func testConstrainTwoAxisAnchors() {
        let constraint = view1.constrain(.leading, to: .trailing, of: view2, constant: 4)
        XCTAssertEqual(constraint.firstAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.trailingAnchor)
        XCTAssertEqual(constraint.constant, 4)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainTwoDimensionAnchors() {
        let constraint = view1.constrain(.width, relation: .greaterThanOrEqual, to: .height, of: view2, multiplier: 5, constant: 2)
        XCTAssertEqual(constraint.firstAnchor, view1.widthAnchor)
        XCTAssertEqual(constraint.secondAnchor, view2.heightAnchor)
        XCTAssertEqual(constraint.multiplier, 5)
        XCTAssertEqual(constraint.constant, 2)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
    }

    func testConstrainViewAnchorToLayoutGuideAnchor() {
        let layoutGuide = LayoutGuide()
        view2.addLayoutGuide(layoutGuide)
        let constraint = view1.constrain(.leading, to: .trailing, of: layoutGuide, constant: 2)
        XCTAssertEqual(constraint.firstAnchor, view1.leadingAnchor)
        XCTAssertEqual(constraint.secondAnchor, layoutGuide.trailingAnchor)
        XCTAssertEqual(constraint.constant, 2)
        XCTAssertEqual(constraint.relation, .equal)
    }

    func testConstrainTwoAnchors_defaults() {
        let constraint = view1.constrain(.leading, to: .trailing, of: view2)
        testDefaults(for: constraint)
    }

    // MARK: - Helpers

    func testDefaults(for constraint: NSLayoutConstraint, constant: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(constraint.constant, constant, file: file, line: line)
        XCTAssertEqual(constraint.priority, 1000, file: file, line: line)
        XCTAssertEqual(constraint.relation, .equal, file: file, line: line)
        XCTAssertEqual(constraint.multiplier, 1)
        XCTAssert(constraint.isActive, file: file, line: line)
    }

}
