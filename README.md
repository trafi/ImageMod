[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

# ImageMod

Modify and compose images with nice Swift syntax, perserve vector data.

# Usage

Just chain operations and call `.image` to retrieve final `UIImage`.

```swift
let niceImage = UIImage(named: "uglyImage")?
    .tinted(.blue)
    .padded(by: 10)
    .scaled(width: 50)
    .zStack(coolImage)
    .image
```

# Installation

### [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)
Open your project in Xcode and select File > Swift Packages > Add Package Dependency. There enter `https://github.com/trafi/ImageMod` as the repository URL.
