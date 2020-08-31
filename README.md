# FXDatabase

## Installation

### CocoaPods

For FXListKit, use the following entry in your Podfile:

```rb
pod 'FXDatabase', '~> 0.1.2'
```

Then run `pod install`.

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/feixue299/FXDatabase.git", from: "0.1.2")
    ],
    // ...
)
