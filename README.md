# MKTween

Very simple and lightweight tween framework in Swift 3.0.
No objects/views bindings for a more flexible use.
Uses CADisplayLink or NSTimer with time interval parameters.

## Requirements
- iOS 8.0+
- Xcode 7.2+

## Usage

### Tween timing functions:

```swift
MKTweenTiming.Linear
MKTweenTiming.BackOut
MKTweenTiming.BackIn
MKTweenTiming.BackInOut
MKTweenTiming.BounceOut
MKTweenTiming.BounceIn
MKTweenTiming.BounceInOut
MKTweenTiming.CircleOut
MKTweenTiming.CircleIn
MKTweenTiming.CircleInOut
MKTweenTiming.CubicOut
MKTweenTiming.CubicIn
MKTweenTiming.CubicInOut
MKTweenTiming.ElasticOut
MKTweenTiming.ElasticIn
MKTweenTiming.ElasticInOut
MKTweenTiming.ExpoOut
MKTweenTiming.ExpoIn
MKTweenTiming.ExpoInOut
MKTweenTiming.QuadOut
MKTweenTiming.QuadIn
MKTweenTiming.QuadInOut
MKTweenTiming.QuartOut
MKTweenTiming.QuartIn
MKTweenTiming.QuartInOut
MKTweenTiming.QuintOut
MKTweenTiming.QuintIn
MKTweenTiming.QuintInOut
MKTweenTiming.SineOut
MKTweenTiming.SineIn
MKTweenTiming.SineInOut
```

### Example of use:
```swift
let period = MKTweenPeriod(duration: 2, delay: 0, startValue: 0, endValue: 1)

let operation = MKTweenOperation(period: period, updateBlock: { (period) -> () in
    
        print(period.progress)
    
    }, completeBlock: { () -> () in
        
        print("complete")
        
    }, timingFunction: MKTweenTiming.ElasticInOut)

MKTween.shared.addTweenOperation(operation)
```

The good thing with swift is now you can make attributes optional to reduce unwanted attributes like:
```swift
let period = MKTweenPeriod(duration: 2) // This will default delay to 0, startValue to 0 and endValue to 1

let operation = MKTweenOperation(period: period, updateBlock: { (period) -> () in
    print(period.progress)
}) // timingFunction will default to MKTweenTiming.Linear
```

### MKTween instances
Many times I have seen unique way of using tweens to be init in only one way and removes the ability of using multiple instances. So you can be sure to not forget variables to setup.
Here ways you can allocate:
```swift
let tween = MKTween.shared
let tween = MKTween.shared()
let tween = MKTween.shared(.Default) // Use CADisplayLink 
let tween = MKTween.shared(.DisplayLink) // Use CADisplayLink 
let tween = MKTween.shared(.Timer) // Use NSTimer 
let tween = MKTween.shared(.None) // If you don't want any tick system to use your own, calling update(timeStamp:) yourself

let tween = MKTween()
let tween = MKTween(.Default)
let tween = MKTween(.DisplayLink)
let tween = MKTween(.Timer)
let tween = MKTween(.None)
```

### Technics
**Setting up time intervals**
```swift
public var frameInterval: Int = 1 // Used for CADisplayLink. Defines how many display frames must pass between each time the display link fires. Can check apple documentation.
public var timerInterval: NSTimeInterval = 1.0/60.0 // Base on a 60 fps rate by default.
```

**Get tween values without using ticks or MKTween**
```swift
let period = MKTweenPeriod(duration:1) // will default to startValue 0 and endValue to 1
let operation = MKTweenOperation(period: period, timingFunction: MKTweenTiming.BackInOut)
let tweenValues = operation.tweenValues(UInt(count))

for progress in tweenValues {
    
    // do something with it
}
```

**Pause**
```swift
tween.paused = true
```

**Reverse a tween while it is running**
```swift
operation.reverse() // This will basically exchange startValue and endValue, but will use the same time already progressed to animated the other side.
```

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8.**

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build MKTween 2.0+.

To integrate MKTween into your Xcode project using CocoaPods, specify it in your `Podfile`:

> Finally working!!!

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'MKTween', '~> 2.0'
```

Then, run the following command:

```bash
$ pod install
```

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add MKTween as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/kmalkic/MKTween.git
```

- Open the new `MKTween` folder, and drag the `MKTween.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `MKTween.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `MKTween.xcodeproj` folders each with two different versions of the `MKTween.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `MKTween.framework`. 
    
- And that's it!

> The `MKTween.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

## Credits

Kevin Malkic

## License

MKTween is released under the MIT license. See LICENSE for details.