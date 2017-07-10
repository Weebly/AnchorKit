//
//  NSLayoutConstraint+AnchorKit_Tests.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/22/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

import XCTest
@testable import AnchorKit

class NSLayoutConstraint_AnchorKit_Tests: XCTestCase {

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

    func testSingleConstraint_activate() {
        let constraint = view1.constrain(.top, to: view2)
        constraint.isActive = false
        XCTAssert(constraint === constraint.activate())
        XCTAssertTrue(constraint.isActive)
    }

    func testArrayOfConstraints_activate() {
        let constraints = view1.constrain(.top, .bottom, to: view2)
        constraints.forEach { $0.isActive = false }
        XCTAssertEqual(constraints, constraints.activate())
        XCTAssertTrue(constraints.filter { !$0.isActive }.isEmpty)
    }

    func testSingleConstraint_deactivate() {
        let constraint = view1.constrain(.top, to: view2)
        XCTAssert(constraint === constraint.deactivate())
        XCTAssertFalse(constraint.isActive)
    }

    func testArrayOfConstraints_deactivate() {
        let constraints = view1.constrainEdges(to: view2)
        XCTAssertEqual(constraints, constraints.deactivate())
        XCTAssertTrue(constraints.filter { $0.isActive }.isEmpty)
    }

    func testSingleConstraint_offset() {
        let constraint = view1.constrain(.bottom, to: .top, of: view2).offset(14.2)
        XCTAssertEqual(constraint.constant, 14.2)
    }

    func testSingleConstraint_updateOffset() {
        let constraint = view1.constrain(.bottom, to: .top, of: view2)
        constraint.offset(14.2)
        XCTAssertEqual(constraint.constant, 14.2)
    }

    func testArrayOfConstraints_offset() {
        let constraint = view1.constrainEdges(to: view2).offset(16.1)
        XCTAssertEqual(Set(constraint.map({ $0.constant })), Set([16.1]))
    }

    func testArrayOfConstraints_updateOffsets() {
        let constraint = view1.constrainEdges(to: view2)
        constraint.updateOffsets(16.1)
        XCTAssertEqual(Set(constraint.map({ $0.constant })), Set([16.1]))
    }

    func testSingleConstraint_inset() {
        let constraint = view1.constrain(.bottom, to: view2).inset(30)
        XCTAssertEqual(constraint.constant, -30)
    }

    func testAttributes_inset() {
        XCTAssertEqual(view1.constrain(.left, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.right, to: view2).inset(5).constant, -5)
        XCTAssertEqual(view1.constrain(.top, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.bottom, to: view2).inset(5).constant, -5)
        XCTAssertEqual(view1.constrain(.leading, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.trailing, to: view2).inset(5).constant, -5)
        XCTAssertEqual(view1.constrain(.width, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.height, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.centerX, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.centerY, to: view2).inset(5).constant, 5)
        XCTAssertEqual(view1.constrain(.lastBaseline, to: view2).inset(5).constant, -5)
        XCTAssertEqual(view1.constrain(.firstBaseline, to: view2).inset(5).constant, 5)
    }

    func testSingleConstraint_updateInset() {
        let constraint = view1.constrain(.bottom, to: view2)
        constraint.updateInset(42)
        XCTAssertEqual(constraint.constant, -42)
    }

    func testArrayOfConstraints_inset() {
        let constraints = view1.constrain(.leading, .trailing, .width, to: view2).inset(30)
        XCTAssertEqual(constraints.map({ $0.constant }), [30, -30, 30])
    }

    func testArrayOfConstraints_updateInsets() {
        let constraints = view1.constrain(.leading, .trailing, .width, to: view2)
        constraints.updateInsets(30)
        XCTAssertEqual(constraints.map({ $0.constant }), [30, -30, 30])
    }

    func testArrayOfConstraints_insetHorizontal() {
        let constraints = view1.constrain(.leading, .trailing, .top, .width, .right, to: view2).insetHorizontal(20)
        XCTAssertEqual(constraints.map({ $0.constant }), [20, -20, 0, 0, -20])
    }

    func testArrayOfConstraints_insetVertical() {
        let constraints = view1.constrain(.leading, .trailing, .top, .bottom, .centerY, .centerX, to: view2).insetVertical(20)
        XCTAssertEqual(constraints.map({ $0.constant }), [0, 0, 20, -20, 20, 0])
    }

    func testArrayOfConstraints_updateHorizontalInsets() {
        let constraints = view1.constrain(.leading, .trailing, .top, .width, .right, to: view2)
        constraints.updateHorizontalInsets(20)
        XCTAssertEqual(constraints.map({ $0.constant }), [20, -20, 0, 0, -20])
    }

    func testArrayOfConstraints_updateVerticalInset() {
        let constraints = view1.constrain(.leading, .trailing, .top, .bottom, .centerY, .centerX, to: view2)
        constraints.updateVerticalInsets(20)
        XCTAssertEqual(constraints.map({ $0.constant }), [0, 0, 20, -20, 20, 0])
    }

    func testLayoutAttribute_isHorizontal() {
        XCTAssertTrue(NSLayoutAttribute.left.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.right.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.top.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.bottom.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.leading.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.trailing.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.width.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.height.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.centerX.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.centerY.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.lastBaseline.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.firstBaseline.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.leftMargin.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.rightMargin.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.topMargin.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.bottomMargin.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.leadingMargin.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.trailingMargin.isHorizontal)
        XCTAssertTrue(NSLayoutAttribute.centerXWithinMargins.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.centerYWithinMargins.isHorizontal)
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isHorizontal)
    }

    func testLayoutAttribute_isVertical() {
        XCTAssertFalse(NSLayoutAttribute.left.isVertical)
        XCTAssertFalse(NSLayoutAttribute.right.isVertical)
        XCTAssertTrue(NSLayoutAttribute.top.isVertical)
        XCTAssertTrue(NSLayoutAttribute.bottom.isVertical)
        XCTAssertFalse(NSLayoutAttribute.leading.isVertical)
        XCTAssertFalse(NSLayoutAttribute.trailing.isVertical)
        XCTAssertFalse(NSLayoutAttribute.width.isVertical)
        XCTAssertFalse(NSLayoutAttribute.height.isVertical)
        XCTAssertFalse(NSLayoutAttribute.centerX.isVertical)
        XCTAssertTrue(NSLayoutAttribute.centerY.isVertical)
        XCTAssertTrue(NSLayoutAttribute.lastBaseline.isVertical)
        XCTAssertTrue(NSLayoutAttribute.firstBaseline.isVertical)
        XCTAssertFalse(NSLayoutAttribute.leftMargin.isVertical)
        XCTAssertFalse(NSLayoutAttribute.rightMargin.isVertical)
        XCTAssertTrue(NSLayoutAttribute.topMargin.isVertical)
        XCTAssertTrue(NSLayoutAttribute.bottomMargin.isVertical)
        XCTAssertFalse(NSLayoutAttribute.leadingMargin.isVertical)
        XCTAssertFalse(NSLayoutAttribute.trailingMargin.isVertical)
        XCTAssertFalse(NSLayoutAttribute.centerXWithinMargins.isVertical)
        XCTAssertTrue(NSLayoutAttribute.centerYWithinMargins.isVertical)
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isVertical)
    }

}
