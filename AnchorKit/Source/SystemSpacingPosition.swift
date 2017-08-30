//
//  SystemSpacingPosition.swift
//  AnchorKit
//
//  Created by Eddie Kaiger on 7/7/17.
//  Copyright © 2017 Eddie Kaiger. All rights reserved.
//

/**
 An enum representing positioning between anchors used to create system spacing constraints.
 Anchors on the horizontal axis need to use `.after`.
 Anchors on the vertical axis need to use `.below`.
 */
@available (iOS 11, tvOS 11, *)
public enum SystemSpacingPosition {

    /// Positioning for horizontal anchors used in system spacing constraints.
    case after

    /// Positioning for vertical anchors used in system spacing constraints.
    case below
}
