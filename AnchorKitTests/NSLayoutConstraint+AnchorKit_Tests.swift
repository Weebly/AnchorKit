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

    func testActivateConstraint() {
        let constraint = view1.constrain(.top, to: view2)
        constraint.isActive = false
        XCTAssert(constraint === constraint.activate())
        XCTAssertTrue(constraint.isActive)
    }

    func testDeactivateConstraint() {
        let constraint = view1.constrain(.top, to: view2)
        constraint.isActive = true
        XCTAssert(constraint === constraint.deactivate())
        XCTAssertFalse(constraint.isActive)
    }

    func testSingleConstraint_offset() {
        let constraint = view1.constrain(.bottom, to: .top, of: view2).offset(14.2)
        XCTAssertEqual(constraint.constant, 14.2)
    }

    func testArrayOfConstraints_offset() {
        let constraint = view1.constrainEdges(to: view2).offset(16.1)
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

    func testArrayOfConstraints_updateInset() {
        let constraints = view1.constrain(.leading, .trailing, .width, to: view2)
        constraints.updateInset(30)
        XCTAssertEqual(constraints.map({ $0.constant }), [30, -30, 30])
    }

}
