# vImageProcessor

[![CI Status](http://img.shields.io/travis/dreampiggy/vImageProcessor.svg?style=flat)](https://travis-ci.org/dreampiggy/vImageProcessor)
[![Version](https://img.shields.io/cocoapods/v/vImageProcessor.svg?style=flat)](http://cocoapods.org/pods/vImageProcessor)
[![License](https://img.shields.io/cocoapods/l/vImageProcessor.svg?style=flat)](http://cocoapods.org/pods/vImageProcessor)
[![Platform](https://img.shields.io/cocoapods/p/vImageProcessor.svg?style=flat)](http://cocoapods.org/pods/vImageProcessor)

## Description

This is a wrapper to use [vImage framework](https://developer.apple.com/library/content/documentation/Performance/Conceptual/vImage/Introduction/Introduction.html) for image processing. Currently it support [
Alpha Compositing](https://developer.apple.com/library/content/documentation/Performance/Conceptual/vImage/AlphaCompositingOperations/AlphaCompositingOperations.html#//apple_ref/doc/uid/TP30001001-CH208-SW1) and [Geometry](https://developer.apple.com/library/content/documentation/Performance/Conceptual/vImage/GeometricOperations/GeometricOperations.html) including thesse:

+ Alpha Compositing for image and color
+ Alpha Compositing for image and image
+ Image Scale
+ Image Cropping
+ Image Flipping
+ Image Rotation
+ Image Shearing
+ Image Affine Transform

All these methods use vImage API but not Core Graphics to do image processing, which is more performant.

This project is more like a demo to show how vImage can be used to benefit some hign-efficient image processing on Apple platform. You can also use these methods in your own image framework.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

There are 8 demo cases to show the feature about vImage. Currently it do not have some powerful feature like [Convolution](https://en.wikipedia.org/wiki/Kernel_\(image_processing\)) or [vDSP](https://developer.apple.com/library/content/documentation/Performance/Conceptual/vDSP_Programming_Guide/Introduction/Introduction.html), because it need more knowledge about [DSP](https://en.wikipedia.org/wiki/Digital_signal_processing). Through Accelerate and vImage support these feature, [GPUImage](https://github.com/BradLarson/GPUImage) may be a better place to get start.

## Requirements

iOS/macOS/tvOS/watchOS version which support vImage framework, means:

+ iOS 5+
+ macOS 10.3+
+ tvOS 9+
+ watchOS 2+

## Installation

vImageProcessor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'vImageProcessor'
```

## Screenshot

Alpha Compositing | Cropping | Affine Transform
:-: | :-: | :-:
![](https://raw.githubusercontent.com/dreampiggy/vImageProcessor/master/Example/Screenshot/Screenshot1.png) | ![](https://raw.githubusercontent.com/dreampiggy/vImageProcessor/master/Example/Screenshot/Screenshot2.png) | ![](https://raw.githubusercontent.com/dreampiggy/vImageProcessor/master/Example/Screenshot/Screenshot3.png)

## Author

DreamPiggy

## License

vImageProcessor is available under the MIT license. See the LICENSE file for more info.
