# MKTween

Very simple and lightweight tween framework in Swift 5.0.
No objects/views bindings for a more flexible use.
Uses CADisplayLink or NSTimer with time interval parameters.

Since 4.0+ you can now use Groups and Sequences to chain animations.
If you used 3.2 and lower, you will have to update your code to use 4.0+!

Please share if you have any suggestions or comments.
Thanks

## Requirements
- iOS 11.0+
- Xcode 10.2+

## Usage

### Tween timing functions:

```swift
Timing.linear
Timing.backOut
Timing.backIn
Timing.backInOut
Timing.bounceOut
Timing.bounceIn
Timing.bounceInOut
Timing.circleOut
Timing.circleIn
Timing.circleInOut
Timing.cubicOut
Timing.cubicIn
Timing.cubicInOut
Timing.elasticOut
Timing.elasticIn
Timing.elasticInOut
Timing.expoOut
Timing.expoIn
Timing.expoInOut
Timing.quadOut
Timing.quadIn
Timing.quadInOut
Timing.quartOut
Timing.quartIn
Timing.quartInOut
Timing.quintOut
Timing.quintIn
Timing.quintInOut
Timing.sineOut
Timing.sineIn
Timing.sineInOut
Timing.custom()
```

### Single Tween:
```swift
let period = Period<CGFloat>(start: 0, end: 1).set(update: { (period) in
    print(period.progress)
}) {
    print("complete")
}.set(timingMode: .elasticInOut)
Tween.shared.add(period: period)
```

Now supports CGPoint, CGSize, CGRect and UIColor.

```swift
let period = Period<CGRect>(start: .zero, end: CGRect(x: 10, y: 10, width: 100, height: 200), duration: 2).set(update: { (period) in
    print(period.progress)
}) {
    print("complete")
}.set(timingMode: .elasticInOut)
Tween.shared.add(period: period)
```

### Group Tween
```swift
let periods: [BasePeriod] = [
    Period<CGFloat>(start: 0, end: 200, duration: 1).set(update: { [weak self] period in
        if let circleView = self?.circleView {
            var origin = circleView.center
            origin.x = 20 + (period.progress)
            circleView.center = origin
        }
    }).set(timingMode: .linear),
    Period<CGFloat>(start: 0, end: 200, duration: 1).set(update: { [weak self] period in
        if let circleView = self?.circleView {
            var origin = circleView.center
            origin.y = 160 + (period.progress)
            circleView.center = origin
        }
    }).set(timingMode: .quadInOut)
]
let group = Group(periods: periods)
    .set(update: { group in
        print("\(group.periodFinished.filter { $0 }.count) finished on \(group.periodFinished.count)")
    }) {
        print("complete")
}
Tween.shared.add(period: group)
```

### Sequence Tween
```swift
let periods: [BasePeriod] = [
    Period<CGFloat>(start: 0, end: 200, duration: 1).set(update: { [weak self] period in
        if let circleView = self?.circleView {
            var origin = circleView.center
            origin.x = 20 + (period.progress)
            circleView.center = origin
        }
    }).set(timingMode: .linear),
    Period<CGFloat>(start: 0, end: 200, duration: 1).set(update: { [weak self] period in
        if let circleView = self?.circleView {
            var origin = circleView.center
            origin.y = 160 + (period.progress)
            circleView.center = origin
        }
    }).set(timingMode: .quadInOut)
]
let sequence = MKTween.Sequence(periods: periods)
    .set(update: { sequence in
        print("\(sequence.currentPeriodIndex) finished on \(sequence.periods.count)")
    }) {
        print("complete")
}
Tween.shared.add(period: sequence)
```

You can also combine Group and Sequence as you want.

### Tween instances
Many times I have seen unique way of using tweens to be init in only one way and removes the ability of using multiple instances. So you can be sure to not forget variables to setup.
Here ways you can allocate:
```swift
let tween = Tween.shared
let tween = Tween.shared()
let tween = Tween.shared(.default) // Use CADisplayLink 
let tween = Tween.shared(.displayLink) // Use CADisplayLink 
let tween = Tween.shared(.timer) // Use NSTimer 
let tween = Tween.shared(.none) // If you don't want any tick system to use your own, calling update(timeStamp:) yourself

let tween = Tween()
let tween = Tween(.default)
let tween = Tween(.displayLink)
let tween = Tween(.timer)
let tween = Tween(.none)
```

### Technics
**Setting up time intervals**
```swift
public var frameInterval: Int = 1 // Used for CADisplayLink. Defines how many display frames must pass between each time the display link fires. Can check apple documentation.
public var timerInterval: NSTimeInterval = 1.0/60.0 // Base on a 60 fps rate by default.
```

**Get tween values without using ticks or **
```swift
let period = Period<CGFloat>(duration:1).set(timingMode: .backInOut) // will default to startValue 0 and endValue to 1
let tweenValues = period.tweenValues(UInt(count))

tweenValues.enumerated().forEach { index, progress in
    
    // do something with it
}
```

**Pause**
```swift
tween.paused = true
```

**Reverse a tween while it is running**
```swift
period.reverse() // This will basically exchange startValue and endValue, but will use the same time already progressed to animated the other side.
```

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 11.**

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.6.1+ is required to build MKTween 4.0+.

To integrate MKTween into your Xcode project using CocoaPods, specify it in your `Podfile`:

> Finally working!!!

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

pod 'MKTween'
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
