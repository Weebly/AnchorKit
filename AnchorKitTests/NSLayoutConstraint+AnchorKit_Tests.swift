//
//  NSLayoutConstraint+AnchorKit_Tests.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/22/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
    typealias LayoutAttribute = NSLayoutConstraint.Attribute
#else
    import UIKit
    typealias LayoutAttribute = NSLayoutAttribute
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

    func testArrayOfConstraints_updateSize() {
        let constraints = view1.constrain(to: CGSize(width: 30, height: 40))
        XCTAssertEqual(constraints.count, 2)
        XCTAssertEqual(constraints[0].constant, 30)
        XCTAssertEqual(constraints[1].constant, 40)
        constraints.updateSize(CGSize(width: 130, height: 140))
        XCTAssertEqual(constraints[0].constant, 130)
        XCTAssertEqual(constraints[1].constant, 140)
    }

    func testArrayOfConstraints_updateSize_ignoresNonSizeConstraints() {
        let constraints = view1.constrain(.width, .leading, .height, toConstant: 100)
        XCTAssertEqual(constraints.count, 3)
        XCTAssertEqual(constraints[0].constant, 100)
        XCTAssertEqual(constraints[1].constant, 100)
        XCTAssertEqual(constraints[2].constant, 100)
        constraints.updateSize(CGSize(width: 130, height: 140))
        XCTAssertEqual(constraints[0].constant, 130)
        XCTAssertEqual(constraints[1].constant, 100)
        XCTAssertEqual(constraints[2].constant, 140)
    }

    func testArrayOfConstraints_updatesSize_ignoresNonConstantConstraints() {
        let widthToViewConstraint = view1.constrain(.width, to: view2)
        let widthToConstantConstraint = view1.constrain(.width, toConstant: 40)
        let heightConstraint = view1.constrain(.height, toConstant: 20)
        [widthToViewConstraint, widthToConstantConstraint, heightConstraint].updateSize(CGSize(width: 130, height: 140))
        XCTAssertEqual(widthToViewConstraint.constant, 0)
        XCTAssertEqual(widthToConstantConstraint.constant, 130)
        XCTAssertEqual(heightConstraint.constant, 140)
    }

    func testLayoutAttribute_isHorizontal() {
        XCTAssertTrue(LayoutAttribute.left.isHorizontal)
        XCTAssertTrue(LayoutAttribute.right.isHorizontal)
        XCTAssertFalse(LayoutAttribute.top.isHorizontal)
        XCTAssertFalse(LayoutAttribute.bottom.isHorizontal)
        XCTAssertTrue(LayoutAttribute.leading.isHorizontal)
        XCTAssertTrue(LayoutAttribute.trailing.isHorizontal)
        XCTAssertFalse(LayoutAttribute.width.isHorizontal)
        XCTAssertFalse(LayoutAttribute.height.isHorizontal)
        XCTAssertTrue(LayoutAttribute.centerX.isHorizontal)
        XCTAssertFalse(LayoutAttribute.centerY.isHorizontal)
        XCTAssertFalse(LayoutAttribute.lastBaseline.isHorizontal)
        XCTAssertFalse(LayoutAttribute.firstBaseline.isHorizontal)
        #if os(iOS) || os(tvOS)
            XCTAssertTrue(LayoutAttribute.leftMargin.isHorizontal)
            XCTAssertTrue(LayoutAttribute.rightMargin.isHorizontal)
            XCTAssertFalse(LayoutAttribute.topMargin.isHorizontal)
            XCTAssertFalse(LayoutAttribute.bottomMargin.isHorizontal)
            XCTAssertTrue(LayoutAttribute.leadingMargin.isHorizontal)
            XCTAssertTrue(LayoutAttribute.trailingMargin.isHorizontal)
            XCTAssertTrue(LayoutAttribute.centerXWithinMargins.isHorizontal)
            XCTAssertFalse(LayoutAttribute.centerYWithinMargins.isHorizontal)
        #endif
        XCTAssertFalse(LayoutAttribute.notAnAttribute.isHorizontal)
    }

    func testLayoutAttribute_isVertical() {
        XCTAssertFalse(LayoutAttribute.left.isVertical)
        XCTAssertFalse(LayoutAttribute.right.isVertical)
        XCTAssertTrue(LayoutAttribute.top.isVertical)
        XCTAssertTrue(LayoutAttribute.bottom.isVertical)
        XCTAssertFalse(LayoutAttribute.leading.isVertical)
        XCTAssertFalse(LayoutAttribute.trailing.isVertical)
        XCTAssertFalse(LayoutAttribute.width.isVertical)
        XCTAssertFalse(LayoutAttribute.height.isVertical)
        XCTAssertFalse(LayoutAttribute.centerX.isVertical)
        XCTAssertTrue(LayoutAttribute.centerY.isVertical)
        XCTAssertTrue(LayoutAttribute.lastBaseline.isVertical)
        XCTAssertTrue(LayoutAttribute.firstBaseline.isVertical)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(LayoutAttribute.leftMargin.isVertical)
            XCTAssertFalse(LayoutAttribute.rightMargin.isVertical)
            XCTAssertTrue(LayoutAttribute.topMargin.isVertical)
            XCTAssertTrue(LayoutAttribute.bottomMargin.isVertical)
            XCTAssertFalse(LayoutAttribute.leadingMargin.isVertical)
            XCTAssertFalse(LayoutAttribute.trailingMargin.isVertical)
            XCTAssertFalse(LayoutAttribute.centerXWithinMargins.isVertical)
            XCTAssertTrue(LayoutAttribute.centerYWithinMargins.isVertical)
        #endif
        XCTAssertFalse(LayoutAttribute.notAnAttribute.isVertical)
    }

    func testLayoutAttribute_isLeft() {
        XCTAssertTrue(LayoutAttribute.left.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.right.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.top.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.bottom.isLeftAttribute)
        XCTAssertTrue(LayoutAttribute.leading.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.trailing.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.width.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.height.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.centerX.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.centerY.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.lastBaseline.isLeftAttribute)
        XCTAssertFalse(LayoutAttribute.firstBaseline.isLeftAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertTrue(LayoutAttribute.leftMargin.isLeftAttribute)
            XCTAssertFalse(LayoutAttribute.rightMargin.isLeftAttribute)
            XCTAssertFalse(LayoutAttribute.topMargin.isLeftAttribute)
            XCTAssertFalse(LayoutAttribute.bottomMargin.isLeftAttribute)
            XCTAssertTrue(LayoutAttribute.leadingMargin.isLeftAttribute)
            XCTAssertFalse(LayoutAttribute.trailingMargin.isLeftAttribute)
            XCTAssertFalse(LayoutAttribute.centerXWithinMargins.isLeftAttribute)
            XCTAssertFalse(LayoutAttribute.centerYWithinMargins.isLeftAttribute)
        #endif
        XCTAssertFalse(LayoutAttribute.notAnAttribute.isLeftAttribute)
    }

    func testLayoutAttribute_isRight() {
        XCTAssertFalse(LayoutAttribute.left.isRightAttribute)
        XCTAssertTrue(LayoutAttribute.right.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.top.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.bottom.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.leading.isRightAttribute)
        XCTAssertTrue(LayoutAttribute.trailing.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.width.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.height.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.centerX.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.centerY.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.lastBaseline.isRightAttribute)
        XCTAssertFalse(LayoutAttribute.firstBaseline.isRightAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(LayoutAttribute.leftMargin.isRightAttribute)
            XCTAssertTrue(LayoutAttribute.rightMargin.isRightAttribute)
            XCTAssertFalse(LayoutAttribute.topMargin.isRightAttribute)
            XCTAssertFalse(LayoutAttribute.bottomMargin.isRightAttribute)
            XCTAssertFalse(LayoutAttribute.leadingMargin.isRightAttribute)
            XCTAssertTrue(LayoutAttribute.trailingMargin.isRightAttribute)
            XCTAssertFalse(LayoutAttribute.centerXWithinMargins.isRightAttribute)
            XCTAssertFalse(LayoutAttribute.centerYWithinMargins.isRightAttribute)
        #endif
        XCTAssertFalse(LayoutAttribute.notAnAttribute.isRightAttribute)
    }

    func testLayoutAttribute_isTop() {
        XCTAssertFalse(LayoutAttribute.left.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.right.isTopAttribute)
        XCTAssertTrue(LayoutAttribute.top.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.bottom.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.leading.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.trailing.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.width.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.height.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.centerX.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.centerY.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.lastBaseline.isTopAttribute)
        XCTAssertFalse(LayoutAttribute.firstBaseline.isTopAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(LayoutAttribute.leftMargin.isTopAttribute)
            XCTAssertFalse(LayoutAttribute.rightMargin.isTopAttribute)
            XCTAssertTrue(LayoutAttribute.topMargin.isTopAttribute)
            XCTAssertFalse(LayoutAttribute.bottomMargin.isTopAttribute)
            XCTAssertFalse(LayoutAttribute.leadingMargin.isTopAttribute)
            XCTAssertFalse(LayoutAttribute.trailingMargin.isTopAttribute)
            XCTAssertFalse(LayoutAttribute.centerXWithinMargins.isTopAttribute)
            XCTAssertFalse(LayoutAttribute.centerYWithinMargins.isTopAttribute)
        #endif
        XCTAssertFalse(LayoutAttribute.notAnAttribute.isTopAttribute)
    }

    func testLayoutAttribute_isBottom() {
        XCTAssertFalse(LayoutAttribute.left.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.right.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.top.isBottomAttribute)
        XCTAssertTrue(LayoutAttribute.bottom.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.leading.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.trailing.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.width.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.height.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.centerX.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.centerY.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.lastBaseline.isBottomAttribute)
        XCTAssertFalse(LayoutAttribute.firstBaseline.isBottomAttribute)
        #if os(iOS) || os(tvOS)
            XCTAssertFalse(LayoutAttribute.leftMargin.isBottomAttribute)
            XCTAssertFalse(LayoutAttribute.rightMargin.isBottomAttribute)
            XCTAssertFalse(LayoutAttribute.topMargin.isBottomAttribute)
            XCTAssertTrue(LayoutAttribute.bottomMargin.isBottomAttribute)
            XCTAssertFalse(LayoutAttribute.leadingMargin.isBottomAttribute)
            XCTAssertFalse(LayoutAttribute.trailingMargin.isBottomAttribute)
            XCTAssertFalse(LayoutAttribute.centerXWithinMargins.isBottomAttribute)
            XCTAssertFalse(LayoutAttribute.centerYWithinMargins.isBottomAttribute)
        #endif
        XCTAssertFalse(LayoutAttribute.notAnAttribute.isBottomAttribute)
    }

}
