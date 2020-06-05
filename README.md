# YMCirclePickerView

Fully customizable horizontal circle picker view.

![YMCirclePickerView](https://s7.gifyu.com/images/YMCirclePickerView.gif)

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

## Requirements

- iOS 9.0+
- Xcode 11+
- Swift 5.0+

## Usage

### Interface Builder Usage

 - Add an empty view in your view and set it's Class to `YMCirclePickerView` with it's module.

![YMCirclePickerView-Interfacebuilder](https://s7.gifyu.com/images/YMCirclePickerView-Interfacebuilder.gif)

 - Add datasource and delegate(if necessary) then customize *layout* and *style* presentations in code.
 
 ```swift
 
import YMCirclePickerView

@IBOutlet private weak var circlePickerView: YMCirclePickerView!

circlePickerView.delegate = self
circlePickerView.dataSource = self
circlePickerView.presentation = YMCirclePickerViewPresentation(
    layoutPresentation: YMCirclePickerViewLayoutPresentation(
		itemSize: CGSize(width: 100.0, height: 100.0),
		unselectedItemSize: CGSize(width: 60.0, height: 60.0),
		spacing: 5.0,
		initialIndex: 3
    ),
    stylePresentation: YMCirclePickerViewStylePresentation(
		selectionColor: .red,
		selectionLineWidth: 4.0,
		titleLabelDistance: 3.0
    )
)
// Or you can use the default one.
circlePickerView.presentation = .default
 ```
 
 ### Code Usage
 
 It's as simple as interface builder implementation. Follow the below code as a guide.
 
 ```swift
let circlePickerView = YMCirclePickerView()
circlePickerView.backgroundColor = .red
circlePickerView.dataSource = self
circlePickerView.presentation = YMCirclePickerViewPresentation(
	layoutPresentation: YMCirclePickerViewLayoutPresentation(
		itemSize: CGSize(width: 75.0, height: 75.0),
		unselectedItemSize: CGSize(width: 30.0, height: 30.0),
		spacing: 15.0
	),
	stylePresentation: YMCirclePickerViewStylePresentation(
		selectionColor: .clear,
		selectionLineWidth: 3.0,
		titleLabelFont: .systemFont(ofSize: 12.0, weight: .thin),
		titleLabelTextColor: .white,
		titleLabelDistance: 3.0
	)
)
stackView.addArrangedSubview(circlePickerView)
 ```
## DataSource and Delegate Methods

- Usage

Your data source class must be inherited from `YMCirclePickerModel`. Simple example for model class:

```swift
class ExampleCirclePickerModel: YMCirclePickerModel {

    override init() {

        super.init()
    }

    convenience init(image: UIImage, title: String) {

        self.init()
        self.image = image
        self.title = title
    }
}

// Use your custom class to conform data source like below

func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, itemForIndex index: Int) -> YMCirclePickerModel? {

	let model = data[index] as ExampleCirclePickerModel
	return model
}
```

- DataSource Methods
```swift
func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, itemForIndex index: Int) -> YMCirclePickerModel?
func ymCirclePickerViewNumberOfItemsInPicker(ymCirclePickerView: YMCirclePickerView) -> Int
```
- Delegate Methods

```swift
func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int)
```

## Installation

### CocoaPods

To use YMCirclePickerView in your project add the following 'Podfile' to your project

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '9.0'
	use_frameworks!

	pod 'YMCirclePickerView'

Then run:

    pod install

### Carthage

Check out the [Carthage](https://github.com/Carthage/Carthage) docs on how to add a install. The `YMCirclePickerView` framework is already setup with shared schemes.

[Carthage Install](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate YMCirclePickerView into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "miletliyusuf/YMCirclePickerView"
```

## TODO

- [ ] Selected image insets

## Meta

Yusuf Miletli – [Linkedin](https://www.linkedin.com/in/miletliyusuf/), miletliyusuf@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/miletliyusuf/YMCirclePickerView](https://github.com/miletliyusuf/YMCirclePickerView)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
