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

    func testAttributes_inset_constant() {
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

    func testArrayOfConstraints_inset_constant() {
        let constraints = view1.constrain(.leading, .trailing, .width, to: view2).inset(30)
        XCTAssertEqual(constraints.map({ $0.constant }), [30, -30, 30])
    }

    func testArrayOfConstraints_inset_edgeInsets() {
        let constraints = view1.constrain(.leading, .trailing, .width, .centerX, .top, .bottom, to: view2).inset(EdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        XCTAssertEqual(constraints.map({ $0.constant }), [2, -4, 0, 0, 1, -3])
    }

    func testArrayOfConstraints_updateInsets_constant() {
        let constraints = view1.constrain(.leading, .trailing, .width, to: view2)
        constraints.updateInsets(30)
        XCTAssertEqual(constraints.map({ $0.constant }), [30, -30, 30])
    }

    func testArrayOfConstraints_updateInsets_edgeInsets() {
        let constraints = view1.constrain(.leading, .trailing, .width, .centerX, .top, .bottom, to: view2)
        constraints.updateInsets(EdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        XCTAssertEqual(constraints.map({ $0.constant }), [2, -4, 0, 0, 1, -3])
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
        #if os(iOS) || os(tvOS)
            XCTAssertTrue(NSLayoutAttribute.leftMargin.isHorizontal)
            XCTAssertTrue(NSLayoutAttribute.rightMargin.isHorizontal)
            XCTAssertFalse(NSLayoutAttribute.topMargin.isHorizontal)
            XCTAssertFalse(NSLayoutAttribute.bottomMargin.isHorizontal)
            XCTAssertTrue(NSLayoutAttribute.leadingMargin.isHorizontal)
            XCTAssertTrue(NSLayoutAttribute.trailingMargin.isHorizontal)
            XCTAssertTrue(NSLayoutAttribute.centerXWithinMargins.isHorizontal)
            XCTAssertFalse(NSLayoutAttribute.centerYWithinMargins.isHorizontal)
        #endif
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
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(NSLayoutAttribute.leftMargin.isVertical)
            XCTAssertFalse(NSLayoutAttribute.rightMargin.isVertical)
            XCTAssertTrue(NSLayoutAttribute.topMargin.isVertical)
            XCTAssertTrue(NSLayoutAttribute.bottomMargin.isVertical)
            XCTAssertFalse(NSLayoutAttribute.leadingMargin.isVertical)
            XCTAssertFalse(NSLayoutAttribute.trailingMargin.isVertical)
            XCTAssertFalse(NSLayoutAttribute.centerXWithinMargins.isVertical)
            XCTAssertTrue(NSLayoutAttribute.centerYWithinMargins.isVertical)
        #endif
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isVertical)
    }

    func testLayoutAttribute_isLeft() {
        XCTAssertTrue(NSLayoutAttribute.left.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.right.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.top.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.bottom.isLeftAttribute)
        XCTAssertTrue(NSLayoutAttribute.leading.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.trailing.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.width.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.height.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerX.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerY.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.lastBaseline.isLeftAttribute)
        XCTAssertFalse(NSLayoutAttribute.firstBaseline.isLeftAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertTrue(NSLayoutAttribute.leftMargin.isLeftAttribute)
            XCTAssertFalse(NSLayoutAttribute.rightMargin.isLeftAttribute)
            XCTAssertFalse(NSLayoutAttribute.topMargin.isLeftAttribute)
            XCTAssertFalse(NSLayoutAttribute.bottomMargin.isLeftAttribute)
            XCTAssertTrue(NSLayoutAttribute.leadingMargin.isLeftAttribute)
            XCTAssertFalse(NSLayoutAttribute.trailingMargin.isLeftAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerXWithinMargins.isLeftAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerYWithinMargins.isLeftAttribute)
        #endif
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isLeftAttribute)
    }

    func testLayoutAttribute_isRight() {
        XCTAssertFalse(NSLayoutAttribute.left.isRightAttribute)
        XCTAssertTrue(NSLayoutAttribute.right.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.top.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.bottom.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.leading.isRightAttribute)
        XCTAssertTrue(NSLayoutAttribute.trailing.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.width.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.height.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerX.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerY.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.lastBaseline.isRightAttribute)
        XCTAssertFalse(NSLayoutAttribute.firstBaseline.isRightAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(NSLayoutAttribute.leftMargin.isRightAttribute)
            XCTAssertTrue(NSLayoutAttribute.rightMargin.isRightAttribute)
            XCTAssertFalse(NSLayoutAttribute.topMargin.isRightAttribute)
            XCTAssertFalse(NSLayoutAttribute.bottomMargin.isRightAttribute)
            XCTAssertFalse(NSLayoutAttribute.leadingMargin.isRightAttribute)
            XCTAssertTrue(NSLayoutAttribute.trailingMargin.isRightAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerXWithinMargins.isRightAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerYWithinMargins.isRightAttribute)
        #endif
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isRightAttribute)
    }

    func testLayoutAttribute_isTop() {
        XCTAssertFalse(NSLayoutAttribute.left.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.right.isTopAttribute)
        XCTAssertTrue(NSLayoutAttribute.top.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.bottom.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.leading.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.trailing.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.width.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.height.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerX.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerY.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.lastBaseline.isTopAttribute)
        XCTAssertFalse(NSLayoutAttribute.firstBaseline.isTopAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(NSLayoutAttribute.leftMargin.isTopAttribute)
            XCTAssertFalse(NSLayoutAttribute.rightMargin.isTopAttribute)
            XCTAssertTrue(NSLayoutAttribute.topMargin.isTopAttribute)
            XCTAssertFalse(NSLayoutAttribute.bottomMargin.isTopAttribute)
            XCTAssertFalse(NSLayoutAttribute.leadingMargin.isTopAttribute)
            XCTAssertFalse(NSLayoutAttribute.trailingMargin.isTopAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerXWithinMargins.isTopAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerYWithinMargins.isTopAttribute)
        #endif
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isTopAttribute)
    }

    func testLayoutAttribute_isBottom() {
        XCTAssertFalse(NSLayoutAttribute.left.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.right.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.top.isBottomAttribute)
        XCTAssertTrue(NSLayoutAttribute.bottom.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.leading.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.trailing.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.width.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.height.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerX.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.centerY.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.lastBaseline.isBottomAttribute)
        XCTAssertFalse(NSLayoutAttribute.firstBaseline.isBottomAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(NSLayoutAttribute.leftMargin.isBottomAttribute)
            XCTAssertFalse(NSLayoutAttribute.rightMargin.isBottomAttribute)
            XCTAssertFalse(NSLayoutAttribute.topMargin.isBottomAttribute)
            XCTAssertTrue(NSLayoutAttribute.bottomMargin.isBottomAttribute)
            XCTAssertFalse(NSLayoutAttribute.leadingMargin.isBottomAttribute)
            XCTAssertFalse(NSLayoutAttribute.trailingMargin.isBottomAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerXWithinMargins.isBottomAttribute)
            XCTAssertFalse(NSLayoutAttribute.centerYWithinMargins.isBottomAttribute)
        #endif
        XCTAssertFalse(NSLayoutAttribute.notAnAttribute.isBottomAttribute)
    }

}
