# CxjParallaxScrollCollection

Create a parallax scrolling effect for your collection sections with **CxjParallaxScrollCollection**. This library allows you to add visually engaging and smooth parallax behavior to sections, while maintaining a familiar UIKit CollectionView API.

## Video Examples of usage
<table>
  <tr>
    <td>
<img src="https://raw.githubusercontent.com/coxijcake/CxjParallaxScrollCollectionExample/main/assets/example_0.gif" alt="Animated GIF" />
    </td>
    <td>
<img src="https://raw.githubusercontent.com/coxijcake/CxjParallaxScrollCollectionExample/main/assets/example_1.gif" alt="Animated GIF" />
    </td>
    <td>
<img src="https://raw.githubusercontent.com/coxijcake/CxjParallaxScrollCollectionExample/main/assets/example_2.gif" alt="Animated GIF" />
    </td>
</table>

---

# Table of contents
- [Introduction](#cxjparallaxscrollcollection)
- [Features](#features)
- [Example project](#example-project)
- [Privacy](#privacy)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
- [How it works](#how-it-works)
  - [Key components](#key-components)
  - [Basic usage](#basic-usage)
- [License](#license)

---

## Features
- **Multiple parallax sections**: Synchronize the scroll of several horizontally-scrolling sections.
- **Custom cells support**: Plug in your own `UICollectionViewCell` designs.
- **Simple API**: Seamlessly integrates with UIKit.
- **iOS 15+ compatibility**.

---

## Example project

A sample project demonstrating the use of **CxjParallaxScrollCollection** is available inside the repository. The demo includes cases like:
- **Transports showcase**: A horizontal list with transport icons.
- **Food & drinks**: Displaying mixed content for food and beverages.
- **Hashtags cloud**: Classic hashtag-style labels.

Simply clone the repository and open the example project to see **CxjToasts** in action.

[Click here to view the example project.](https://github.com/coxijcake/CxjParallaxScrollCollectionExample)

---

## Privacy

**CxjParallaxScrollCollection** does not collect any user data. This library is safe for use in apps with strict privacy requirements.

---

## Installation

### Swift Package Manager
Add the package to your dependencies:
```swift
dependencies: [
    .package(url: "https://github.com/coxijcake/CxjParallaxScrollCollection", from: "1.0.0")
]
```

### Import
```swift
import CxjParallaxScrollCollection
```

---

## How it works

**CxjParallaxScrollCollection** synchronizes the scrolling of multiple horizontal sections using a master scroll view to create a parallax effect.

### Key components

- **ViewController**: The main controller managing the synchronized collection sections.
- **DataSource**: Supplies models and cell types for all sections.
- **Delegate**: Handles user interactions such as item selection.
- **CellModel**: Defines sizing info and configuration data for each cell.
- **ContentCell**: Your custom `UICollectionViewCell` subclass conforming to the protocol.

### Basic usage

1. **Implement your `CellModel`:**
```swift
struct MyCellModel: CxjParallaxScrollCollection.CellModel {
    let title: String
    var requiredWidth: CGFloat { /* calculate width here */ }
}
```

2. **Create your custom cell:**
```swift
final class MyCell: UICollectionViewCell, CxjParallaxScrollCollection.ContentCell {
    func configureWithModel(_ cellModel: CxjParallaxScrollCollection.CellModel) {
        // Configure your cell UI here
    }
}
```

3. **Provide a DataSource & Delegate:**
```swift
final class MyViewController: UIViewController, CxjParallaxScrollCollection.DataSource, CxjParallaxScrollCollection.Delegate {
    // Implement required methods
}
```

4. **Assemble the VC:**
```swift
let parallaxVC = CxjParallaxViewControllerAssembler.assembleWith(layout: layout, dataSource: self, delegate: self)
addChild(parallaxVC)
```

---

## License
**CxjParallaxScrollCollection** is available under the MIT license. See the LICENSE file for details.
