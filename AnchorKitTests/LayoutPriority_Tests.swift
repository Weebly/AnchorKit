//
//  LayoutPriority_Tests.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 2/22/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

#if os(macOS)
    import AppKit
    #if swift(>=3.2)
        typealias Priority = NSLayoutConstraint.Priority
    #else
        typealias Priority = NSLayoutPriority
    #endif
#else
    import UIKit
    typealias Priority = UILayoutPriority
#endif


import XCTest
@testable import AnchorKit


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
        #if swift(>=4.0)
            XCTAssertEqual(constraint.priority.rawValue, 750)
            constraint.priority = Priority(rawValue: 56)
        #else
            XCTAssertEqual(constraint.priority, 750)
            constraint.priority = 56
        #endif
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
        v.resistCompression(with: .high, for: .vertical, .horizontal)
        XCTAssertEqual(v.compressionResistancePriority(for: .vertical), .high)
        XCTAssertEqual(v.compressionResistancePriority(for: .horizontal), .high)
    }

    func testContentHugging() {
        let v = View()
        v.hug(with: .medium, for: .horizontal, .vertical)
        XCTAssertEqual(v.huggingPriority(for: .horizontal), .medium)
        XCTAssertEqual(v.huggingPriority(for: .vertical), .medium)
    }

}
