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
        //XCTAssertEqual(LayoutPriority(rawValue: 250), .low)
        //XCTAssertEqual(LayoutPriority(rawValue: 500), .medium)
    }

    func testConstraint_setLayoutPriority() {
        let constraint = NSLayoutConstraint()
        constraint.layoutPriority = .high
        XCTAssertEqual(constraint.priority, 750)
    }

}
