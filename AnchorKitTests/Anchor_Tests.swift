//
//  Anchor_Tests.swift
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

class Anchor_Tests: XCTestCase {

    func testLayoutAnchorForView() {
        let view = View()
        XCTAssertEqual(Anchor.leading.layoutAnchor(for: view), view.leadingAnchor)
        XCTAssertEqual(Anchor.trailing.layoutAnchor(for: view), view.trailingAnchor)
        XCTAssertEqual(Anchor.left.layoutAnchor(for: view), view.leftAnchor)
        XCTAssertEqual(Anchor.right.layoutAnchor(for: view), view.rightAnchor)
        XCTAssertEqual(Anchor.top.layoutAnchor(for: view), view.topAnchor)
        XCTAssertEqual(Anchor.bottom.layoutAnchor(for: view), view.bottomAnchor)
        XCTAssertEqual(Anchor.width.layoutAnchor(for: view), view.widthAnchor)
        XCTAssertEqual(Anchor.height.layoutAnchor(for: view), view.heightAnchor)
        XCTAssertEqual(Anchor.centerX.layoutAnchor(for: view), view.centerXAnchor)
        XCTAssertEqual(Anchor.centerY.layoutAnchor(for: view), view.centerYAnchor)
        XCTAssertEqual(Anchor.firstBaseline.layoutAnchor(for: view), view.firstBaselineAnchor)
        XCTAssertEqual(Anchor.lastBaseline.layoutAnchor(for: view), view.lastBaselineAnchor)
    }

    func testLayoutAnchorForLayoutGuide() {
        let layoutGuide = LayoutGuide()
        XCTAssertEqual(Anchor.leading.layoutAnchor(for: layoutGuide), layoutGuide.leadingAnchor)
        XCTAssertEqual(Anchor.trailing.layoutAnchor(for: layoutGuide), layoutGuide.trailingAnchor)
        XCTAssertEqual(Anchor.left.layoutAnchor(for: layoutGuide), layoutGuide.leftAnchor)
        XCTAssertEqual(Anchor.right.layoutAnchor(for: layoutGuide), layoutGuide.rightAnchor)
        XCTAssertEqual(Anchor.top.layoutAnchor(for: layoutGuide), layoutGuide.topAnchor)
        XCTAssertEqual(Anchor.bottom.layoutAnchor(for: layoutGuide), layoutGuide.bottomAnchor)
        XCTAssertEqual(Anchor.width.layoutAnchor(for: layoutGuide), layoutGuide.widthAnchor)
        XCTAssertEqual(Anchor.height.layoutAnchor(for: layoutGuide), layoutGuide.heightAnchor)
        XCTAssertEqual(Anchor.centerX.layoutAnchor(for: layoutGuide), layoutGuide.centerXAnchor)
        XCTAssertEqual(Anchor.centerY.layoutAnchor(for: layoutGuide), layoutGuide.centerYAnchor)
    }

}
