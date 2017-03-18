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

    // MARK: - Activation

    func testConstrainTwoAxisAnchors_activatesConstraint() {
        let equalConstraint = view1.constrain(view1.leadingAnchor, relation: .equal, to: view2.trailingAnchor, constant: 0)
        let greaterConstraint = view1.constrain(view1.leadingAnchor, relation: .greaterThanOrEqual, to: view2.trailingAnchor, constant: 0)
        let lessConstraint = view1.constrain(view1.leadingAnchor, relation: .lessThanOrEqual, to: view2.trailingAnchor, constant: 0)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testConstrainTwoDimensionAnchors_activatesConstraint() {
        let equalConstraint = view1.constrain(view1.widthAnchor, relation: .equal, to: view2.heightAnchor, multiplier: 1, constant: 0)
        let greaterConstraint = view1.constrain(view1.widthAnchor, relation: .greaterThanOrEqual, to: view2.heightAnchor, multiplier: 1, constant: 0)
        let lessConstraint = view1.constrain(view1.widthAnchor, relation: .lessThanOrEqual, to: view2.heightAnchor, multiplier: 1, constant: 0)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    func testConstrainDimensionAnchorToConstant_activatesConstraint() {
        let equalConstraint = view1.constrain(view1.widthAnchor, relation: .equal, to: 10)
        let greaterConstraint = view1.constrain(view1.widthAnchor, relation: .greaterThanOrEqual, to: 10)
        let lessConstraint = view1.constrain(view1.widthAnchor, relation: .lessThanOrEqual, to: 10)
        XCTAssert(equalConstraint.isActive)
        XCTAssert(greaterConstraint.isActive)
        XCTAssert(lessConstraint.isActive)
        XCTAssertEqual(equalConstraint.relation, .equal)
        XCTAssertEqual(greaterConstraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(lessConstraint.relation, .lessThanOrEqual)
    }

    // MARK: - Anchor to constant

    func testConstrainWidthToConstant() {
        let constraint = view1.constrain(.width, toConstant: 20)
        XCTAssertEqual(constraint.constant, 20)
        XCTAssertEqual(constraint.firstAnchor, view1.widthAnchor)
        XCTAssertNil(constraint.secondAnchor)
        XCTAssertEqual(constraint.relation, .equal)
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

    func testConstraintMultipleAnchorsToConstant_lessThanOrEqual() {
        let constraints = view1.constrain(.width, .height, .top, relation: .lessThanOrEqual, toConstant: 20)
        XCTAssertEqual(Set(constraints.map { $0.relation }), [.lessThanOrEqual])
    }

    // MARK: - Anchor to item

    func testConstrainAnchorToItem() {
        let constraint = view1.constrain(.height, to: view2, multiplier: 2, constant: 20)
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

}
