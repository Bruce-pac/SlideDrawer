# SlideDrawer

[![CI Status](https://img.shields.io/travis/Bruce-pac/SlideDrawer.svg?style=flat)](https://travis-ci.org/Bruce-pac/SlideDrawer)
[![Version](https://img.shields.io/cocoapods/v/SlideDrawer.svg?style=flat)](https://cocoapods.org/pods/SlideDrawer)
![Carthage](https://camo.githubusercontent.com/3dc8a44a2c3f7ccd5418008d1295aae48466c141/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f43617274686167652d636f6d70617469626c652d3442433531442e7376673f7374796c653d666c6174)
[![License](https://img.shields.io/cocoapods/l/SlideDrawer.svg?style=flat)](https://cocoapods.org/pods/SlideDrawer)
[![Platform](https://img.shields.io/cocoapods/p/SlideDrawer.svg?style=flat)](https://cocoapods.org/pods/SlideDrawer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+
- Swift 4.2+

## Installation

### CocoaPods

SlideDrawer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SlideDrawer'
```

### Carthage

To integrate SlideDrawer into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```
github "Bruce-pac/SlideDrawer"
```

Then, run the following command to build the SlideDrawer framework:

```
$ carthage update --platform ios
```

At last, you need to set up your Xcode project manually to add the SlideDrawer framework:

1. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.
2. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:

```
/usr/local/bin/carthage copy-frameworks
```

1. Add the paths to the frameworks you want to use under “Input Files”:

```
$(SRCROOT)/Carthage/Build/iOS/SlideDrawer.framework
```

1. Add the paths to the copied frameworks to the “Output Files”:

```
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/SlideDrawer.framework
```

## Usage

```swift
let vc = LeftViewController()
//self is the main/center ViewController
self.sd.show(drawer: vc) //default left
// you can set direction right by this
self.sd.show(drawer: vc) { (letConfig) -> SlideDrawerConfiguration in
                var config = letConfig
                config.direction = .right
                return config
            }
```

See Examples for more usage

## Author

Bruce-pac, Bruce_pac312@foxmail.com

## License

SlideDrawer is available under the MIT license. See the LICENSE file for more info.
