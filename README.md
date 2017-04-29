
<img src="https://github.com/Weebly/Anchor/blob/master/Images/Anchor.png" alt="Anchor" />

# The Basics
**Anchor** makes it easy to create constraints using AutoLayout anchors. Here's some example code:

````swift
view1.constrain(.centerX, .centerY, to: view)
view1.constrain(.height, .width, toConstant: 200)

view2.constrain(.top, to: view1, constant: 20)
view2.constrain(.leading, .trailing, to: view1)
view2.constrain(.height, relation: .lessThanOrEqual, to: view1, multiplier: 1.6)
view2.constrain(.bottom, to: view, constant: -15, priority: .high)

let bottomConstraint = view3.constrain(.bottom, to: .top, of: view1.layoutMarginsGuide)
let topAndSideConstraints = view3.constrain(.leading, .trailing, .top, to: view)

view4.constrainEdges(to: view3, inset: 10)
````

# Features

- No more `isActive = true` after every line (**constraints are returned pre-activated** 🎉) 
- Automatically takes care of `translatesAutoresizingMaskIntoConstraints = false`
- **Constrain to the edges of another view** with `constrainEdges(to:inset:priority)`
- Works with both **layout guides and views**
- Works on **all 3 platforms** that support AutoLayout constraints (iOS, macOS, tvOS)
- **Set multiple constraints on one line**: `view1.constrain(.leading, .trailing, .centerX, to: view2)`

# Requirements

iOS 9.0+, macOS 10.11+, tvOS 9.0+


# Installation

### CocoaPods:
````
pod 'Anchor'
````

### Carthage:
````
github "Weebly/Anchor"
````

# Usage



# Support
For questions, support, and suggestions, please open up an issue.

# License
**Anchor** is available under the MIT license. See the LICENSE file for more info.












