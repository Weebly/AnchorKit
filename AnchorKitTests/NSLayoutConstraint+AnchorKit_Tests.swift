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
    
}
