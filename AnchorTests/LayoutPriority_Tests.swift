//
//  LayoutPriority_Tests.swift
//  Anchor
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
@testable import Anchor


class LayoutPriority_Tests: XCTestCase {
    
    func testLayoutPriorityRawValues() {
        XCTAssertEqual(LayoutPriority.low.rawValue, 250)
        XCTAssertEqual(LayoutPriority.medium.rawValue, 500)
        XCTAssertEqual(LayoutPriority.high.rawValue, 750)
        XCTAssertEqual(LayoutPriority.required.rawValue, 1000)
    }

    func testConstraint_withPriorityEnum() {
        let constraint = NSLayoutConstraint().withPriority(.low)
        XCTAssertEqual(constraint.priority, 250)
    }

    func testConstraint_withPriorityValue() {
        let constraint = NSLayoutConstraint().withPriority(630)
        XCTAssertEqual(constraint.priority, 630)
    }

    func testConstraint_updatePriority() {
        let constraint = NSLayoutConstraint().withPriority(.low)
        constraint.updatePriority(.high)
        XCTAssertEqual(constraint.priority, 750)
    }

}
