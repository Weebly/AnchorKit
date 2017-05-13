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
    
    func testRawValues() {
        XCTAssertEqual(LayoutPriority.low.rawValue, 250)
        XCTAssertEqual(LayoutPriority.medium.rawValue, 500)
        XCTAssertEqual(LayoutPriority.high.rawValue, 750)
        XCTAssertEqual(LayoutPriority.required.rawValue, 1000)
        XCTAssertEqual(LayoutPriority.custom(32).rawValue, 32)
    }

    func testInitWithRawValue() {
        XCTAssertEqual(LayoutPriority(rawValue: 250), .low)
        XCTAssertEqual(LayoutPriority(rawValue: 500), .medium)
        XCTAssertEqual(LayoutPriority(rawValue: 750), .high)
        XCTAssertEqual(LayoutPriority(rawValue: 1000), .required)
        XCTAssertEqual(LayoutPriority(rawValue: 42), .custom(42))
    }

    func testConstraint_layoutPriority() {
        let constraint = NSLayoutConstraint()
        constraint.layoutPriority = .high
        XCTAssertEqual(constraint.priority, 750)
        constraint.priority = 56
        XCTAssertEqual(constraint.layoutPriority, .custom(56))
    }

    func testComparable() {
        XCTAssertLessThan(LayoutPriority.low, .high)
        XCTAssertGreaterThan(LayoutPriority.custom(501), .medium)
    }

    func testAddition() {
        XCTAssertEqual((LayoutPriority.high + 1).rawValue, 751)
    }

    func testSubtraction() {
        XCTAssertEqual((LayoutPriority.medium - 20).rawValue, 480)
    }

    func testContentCompressionResistance() {
        let v = View()
        v.setContentCompressionResistancePriority(.high, for: .vertical)
        XCTAssertEqual(v.contentCompressionResistancePriority(for: .vertical), .high)
        XCTAssertEqual(v.contentCompressionResistancePriority(for: .vertical), 750)
    }

    func testContentHugging() {
        let v = View()
        v.setContentHuggingPriority(.medium, for: .horizontal)
        XCTAssertEqual(v.contentHuggingPriority(for: .horizontal), .medium)
        XCTAssertEqual(v.contentHuggingPriority(for: .horizontal), 500)
    }

}
