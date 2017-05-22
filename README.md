
<img src="Images/AnchorKit.png" alt="AnchorKit" />

### ***AnchorKit** provides a simple, intuitive way to create layouts using anchors.*

# The Basics
Here's some example code:

````swift
// Multiple constraints on one line
myView.constrain(.centerX, .centerY, to: anotherView)

// Set height/width equal to a constant
myView.constrain(.height, .width, toConstant: 200)

// Set offset (constant)
myView.constrain(.leading, to: .trailing, of: anotherView).offset(20)

// Set insets
myView.constrain(.leading, .trailing, to: anotherView).inset(24)

// Set the relation and multiplier
myView.constrain(.height, relation: .lessThanOrEqual, to: anotherView, multiplier: 1.6)

// Set the priority
myView.constrain(.bottom, to: view, priority: .high).offset(-15)

// Return value for single constraint is NSLayoutConstraint
let bottomConstraint = myView.constrain(.bottom, to: .top, of: anotherView.layoutMarginsGuide)

// Return value for multiple constraints is [NSLayoutConstraint]
let topAndSideConstraints = myView.constrain(.leading, .trailing, .top, to: anotherView)

// One-line edge constraints with insets
let edgeConstraints = myView.constrainEdges(to: anotherView).inset(10)
````

# Features

- Simple, intuitive, Swifty syntax
- No more `isActive = true` after every line (**constraints are returned pre-activated** 🎉) 
- Automatically takes care of `translatesAutoresizingMaskIntoConstraints = false`
- Works with both **layout guides and views**
- Works on **all 3 platforms** that support AutoLayout constraints (iOS, macOS, tvOS)
- No proprietary classes to deal with; return values are `NSLayoutConstraint` or `[NSLayoutConstraint]`
- Use any number types (`Int`, `Double`, `Float`, etc.), no need to cast to `CGFloat`


# Requirements

iOS 9.0+, macOS 10.11+, tvOS 9.0+


# Installation

### CocoaPods:
````
pod 'AnchorKit'
````

### Carthage:
````
github "Weebly/AnchorKit"
````

# Usage



# Support
For questions, support, and suggestions, please open up an issue.

# License
**AnchorKit** is available under the MIT license. See the LICENSE file for more info.












