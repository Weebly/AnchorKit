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

}
