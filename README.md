# MKTween

Very simple and lightweight tween framework in Swift 4.2.
No objects/views bindings for a more flexible use.
Uses CADisplayLink or NSTimer with time interval parameters.

## Requirements
- iOS 9.0+
- Xcode 9.2+

## Usage

### Tween timing functions:

```swift
Timing.Linear
Timing.BackOut
Timing.BackIn
Timing.BackInOut
Timing.BounceOut
Timing.BounceIn
Timing.BounceInOut
Timing.CircleOut
Timing.CircleIn
Timing.CircleInOut
Timing.CubicOut
Timing.CubicIn
Timing.CubicInOut
Timing.ElasticOut
Timing.ElasticIn
Timing.ElasticInOut
Timing.ExpoOut
Timing.ExpoIn
Timing.ExpoInOut
Timing.QuadOut
Timing.QuadIn
Timing.QuadInOut
Timing.QuartOut
Timing.QuartIn
Timing.QuartInOut
Timing.QuintOut
Timing.QuintIn
Timing.QuintInOut
Timing.SineOut
Timing.SineIn
Timing.SineInOut
```

### Example of use:
```swift
let period = Period<CGFloat>(start: 0.0, end: 1.0, duration: 2.0, delay: 0.0)

let operation = OperationTween(period: period, updateBlock: { (period) -> () in
    
        print(period.progress)
    
    }, completeBlock: { () -> () in
        
        print("complete")
        
    }, timingFunction: Timing.ElasticInOut)

Tween.shared.addTweenOperation(operation)
```

Now supports CGPoint, CGSize, CGRect and UIColor.

```swift
let period = Period<CGRect>(start: .zero, end: CGRect(x: 10, y: 10, width: 100, height: 200), duration: 2.0, delay: 0.0)

let operation = OperationTween(period: period, updateBlock: { (period) -> () in

    print(period.progress)

}, completeBlock: { () -> () in

    print("complete")

}, timingFunction: Timing.ElasticInOut)

Tween.shared.addTweenOperation(operation)
```

### MKTween instances
Many times I have seen unique way of using tweens to be init in only one way and removes the ability of using multiple instances. So you can be sure to not forget variables to setup.
Here ways you can allocate:
```swift
let tween = Tween.shared
let tween = Tween.shared()
let tween = Tween.shared(.Default) // Use CADisplayLink 
let tween = Tween.shared(.DisplayLink) // Use CADisplayLink 
let tween = Tween.shared(.Timer) // Use NSTimer 
let tween = Tween.shared(.None) // If you don't want any tick system to use your own, calling update(timeStamp:) yourself

let tween = Tween()
let tween = Tween(.Default)
let tween = Tween(.DisplayLink)
let tween = Tween(.Timer)
let tween = Tween(.None)
```

### Technics
**Setting up time intervals**
```swift
public var frameInterval: Int = 1 // Used for CADisplayLink. Defines how many display frames must pass between each time the display link fires. Can check apple documentation.
public var timerInterval: NSTimeInterval = 1.0/60.0 // Base on a 60 fps rate by default.
```

**Get tween values without using ticks or **
```swift
let period = Period<CGFloat>(duration:1) // will default to startValue 0 and endValue to 1
let operation = OperationTween(period: period, timingFunction: Timing.BackInOut)
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

> **Embedded frameworks require a minimum deployment target of iOS 9.**

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
platform :ios, '9.0'
use_frameworks!

pod 'MKTween', '~> 3.2.1'
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
