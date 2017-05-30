//
//  CGFloatRepresentable.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 5/13/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import CoreGraphics

/**
 A protocol that converts different number types to a `CGFloat` equivalent.
 
 TOOD: Improve in Swift 4 once we have better number protocols.
 */
public protocol CGFloatRepresentable {

    var cgFloatValue: CGFloat { get }

}

// MARK: Number Extensions

extension Int8: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension UInt8: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Int16: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension UInt16: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Int32: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension UInt32: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Int64: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension UInt64: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Int: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension UInt: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Float: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

#if os(macOS)
extension Float80: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}
#endif

extension Double: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension NSNumber: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return CGFloat(floatValue) }
}

extension CGFloat: CGFloatRepresentable {
    public var cgFloatValue: CGFloat { return self }
}

// MARK: - Internal Operators

func == <LeftType: CGFloatRepresentable & Equatable, RightType: CGFloatRepresentable & Equatable>(lhs: LeftType, rhs: RightType) -> Bool {
    return lhs.cgFloatValue == rhs.cgFloatValue
}
