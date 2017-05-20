//
//  ViewController.swift
//  Anchor-iOS
//
//  Created by Eddie Kaiger on 3/31/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import AnchorKit

class ViewController: UIViewController {

    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    let view4 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view1.backgroundColor = .red
        view2.backgroundColor = .blue
        view3.backgroundColor = .green
        view4.backgroundColor = .magenta

        [view1, view2, view3, view4].forEach(view.addSubview)

        setupConstraints()
    }

    private func setupConstraints() {
        view1.constrain(.centerX, .centerY, to: view)
        view1.constrain(.height, .width, toConstant: 100)

        view2.constrain(.top, to: view1).offset(20)
        view2.constrain(.leading, .trailing, to: view1).offset(30)
        view2.constrain(.height, relation: .lessThanOrEqual, to: view1, multiplier: 2.5)

        view2.constrain(.bottom, to: view, priority: .high).offset(-15)

        let bottomConstraint = view3.constrain(.bottom, to: .top, of: view1.layoutMarginsGuide)
        let topAndSideConstraints = view3.constrain(.leading, .trailing, .top, to: view)

        view4.constrainEdges(to: view3).inset(20)

        bottomConstraint.constant = 5
    }

}

