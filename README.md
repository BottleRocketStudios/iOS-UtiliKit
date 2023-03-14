# UtiliKit

![CI Status](https://github.com/BottleRocketStudios/iOS-UtiliKit/actions/workflows/main.yml/badge.svg)
[![Version](https://img.shields.io/cocoapods/v/UtiliKit.svg?style=flat)](http://cocoapods.org/pods/UtiliKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager)
[![Platform](https://img.shields.io/cocoapods/p/UtiliKit.svg?style=flat)](http://cocoapods.org/pods/UtiliKit)
[![codecov](https://codecov.io/gh/BottleRocketStudios/iOS-UtiliKit/branch/master/graph/badge.svg)](https://codecov.io/gh/BottleRocketStudios/iOS-UtiliKit)
[![License](https://img.shields.io/cocoapods/l/UtiliKit.svg?style=flat)](http://cocoapods.org/pods/UtiliKit)

**UtiliKit** provides several useful and often common additions for iOS applications. These extensions, protocols, and structs are designed to simplify boilerplate code as well as remove common "String-typed" use cases.

## Contents

The following implementations are provided:

* [**ActiveLabel**](Documentation/READMEs/ActiveLabel.md) - This subspec provides a `UILabel` subclass that renders gradient "loading" animations while the label's `text` property is set to `nil`.
* [**Container**](Documentation/READMEs/Container.md) - This subspec provides a simple `ContainerViewController` without any built-in navigation construct.
* [**General**](Documentation/READMEs/General.md) - This subspec includes extensions for both `FileManager` and `UIView`. These simplify getting common URLs and programmatically adding views down to simple variables and function calls.
* [**Instantiation**](Documentation/READMEs/Instantiation.md) - This subspec changes "String-typed" view instantiation, view controller instantiation, and reusable view dequeuing into type-safe function calls.
* [**Obfuscation**](Documentation/READMEs/Obfuscation.md) - This subspec provides simple routines to remove plaintext passwords or keys from your source code.
* [**ScrollingPageControl**](Documentation/READMEs/ScrollingPageControl.md) - This subspec provides a view modeled from Apple's `UIPageControl` to allow representation of a large number of pages.
* [**TimelessDate**](Documentation/READMEs/TimelessDate.md) - This subspec is an abstraction away from `Date` and `Calendar`. It is primarily designed to be used for simple scheduling and day comparisons in which the time is less important that the actual day.
* [**Version**](Documentation/READMEs/Version.md) - This subspec simplifies the display of version and build numbers.

## Example

Clone the repo:

```bash
git clone https://github.com/BottleRocketStudios/iOS-UtiliKit.git
```

From here, you can open up `UtiliKit.xcworkspace` and run the "UtiliKit-iOSExample" project.

## Requirements

* iOS 10.0+
* Swift 5.1

## Installation

### Cocoapods

UtiliKit is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'UtiliKit'
```

### Carthage

Add the following to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "BottleRocketStudios/iOS-UtiliKit"
```

Run `carthage update` and follow the steps as described in Carthage's [README](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/BottleRocketStudios/iOS-UtiliKit.git", from: "1.8.0")
]
```

You will then need to choose from the available libraries to add to your project. These libraries should match up with the subspecs available through Cocoapods.

* `UtiliKit` - Imports all of the below libraries available individually.
* `ActiveLabel` - This subspec provides a `UILabel` subclass that renders gradient "loading" animations while the label's `text` property is set to `nil`.
* `ContainerViewController` - This subspec provides a simple `ContainerViewController` without any built-in navigation construct.
* `GeneralUtilities` - This subspec includes extensions for both `FileManager` and `UIView`. These simplify getting common URLs and programmatically adding views down to simple variables and function calls.
* `Instantiation` - This subspec changes "Stringly-typed" view instantiation, view controller instantiation, and reusable view dequeuing into type-safe function calls.
* `Obfuscation` - This subspec provides simple routines to remove plaintext passwords or keys from your source code.
* `ScrollingPageControl` - This subspec provides a view modeled from Apple's `UIPageControl` to allow representation of a large number of pages.
* `TimelessDate` - This subspec is an abstraction away from `Date` and `Calendar`. It is primarily designed to be used for simple scheduling and day comparisons in which the time is less important that the actual day.
* `Versioning` - This subspec simplifies the display of version and build numbers.

## Author

[Bottle Rocket Studios](https://www.bottlerocketstudios.com/)

## License

UtiliKit is available under the Apache 2.0 license. See the LICENSE.txt file for more info.

## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/BottleRocketStudios/iOS-UtiliKit/graphs/contributors
