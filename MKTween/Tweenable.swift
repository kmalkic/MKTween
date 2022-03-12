//
//  Tweenable.swift
//  MKTween
//
//  Created by Kevin Malkic on 08/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import Foundation
import UIKit

public protocol Tweenable {
    static func defaultValue() -> Self
    static func evaluate(start: Self, end: Self, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Self
}

extension Comparable {
    
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension TimeInterval {
    
    internal func deltaTime(from: TimeInterval) -> TimeInterval {
        return from - self
    }
}

extension Double: Tweenable {
    
    public static func defaultValue() -> Double {
        return 0.0
    }
    
    public static func evaluate(start: Double, end: Double, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Double {
        return timingFunction(time, start, end - start, duration)
    }
}

extension Float: Tweenable {
    
    public static func defaultValue() -> Float {
        return 0.0
    }
    
    public static func evaluate(start: Float, end: Float, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Float {
        return Float(timingFunction(time, Double(start), Double(end - start), duration))
    }
}

extension CGFloat: Tweenable {
    
    public static func defaultValue() -> CGFloat {
        return 0.0
    }
    
    public static func evaluate(start: CGFloat, end: CGFloat, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGFloat {
        return CGFloat(timingFunction(time, Double(start), Double(end - start), duration))
    }
}

extension CGSize: Tweenable {
    
    public static func defaultValue() -> CGSize {
        return .zero
    }
    
    public static func evaluate(start: CGSize, end: CGSize, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGSize {
        return CGSize(width: CGFloat.evaluate(start: start.width, end: end.width, time: time, duration: duration, timingFunction: timingFunction),
                      height: CGFloat.evaluate(start: start.height, end: end.height, time: time, duration: duration, timingFunction: timingFunction))
    }
}

extension CGPoint: Tweenable {
    
    public static func defaultValue() -> CGPoint {
        return .zero
    }
    
    public static func evaluate(start: CGPoint, end: CGPoint, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGPoint {
        return CGPoint(x: CGFloat.evaluate(start: start.x, end: end.x, time: time, duration: duration, timingFunction: timingFunction),
                       y: CGFloat.evaluate(start: start.y, end: end.y, time: time, duration: duration, timingFunction: timingFunction))
    }
}

extension CGRect: Tweenable {
    
    public static func defaultValue() -> CGRect {
        return .zero
    }
    
    public static func evaluate(start: CGRect, end: CGRect, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGRect {
        return CGRect(origin: CGPoint.evaluate(start: start.origin, end: end.origin, time: time, duration: duration, timingFunction: timingFunction),
                      size: CGSize.evaluate(start: start.size, end: end.size, time: time, duration: duration, timingFunction: timingFunction))
    }
}

extension UIColor {
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let components = self.cgColor.components else { return nil }
        guard let cgColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: components) else { return nil }
        let color = UIColor(cgColor: cgColor)
        guard let components = color.cgColor.components else { return nil }
        return (
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
        )
    }
}

extension UIColor: Tweenable {
    
    public static func defaultValue() -> Self {
        return self.init()
    }
    
    public class func evaluate(start: UIColor, end: UIColor, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Self {
        
        guard let startColor = start.colorComponents,
            let endColor = end.colorComponents else {
                return self.init()
        }
        
        return self.init(red: CGFloat.evaluate(start: startColor.red, end: endColor.red, time: time, duration: duration, timingFunction: timingFunction),
                       green: CGFloat.evaluate(start: startColor.green, end: endColor.green, time: time, duration: duration, timingFunction: timingFunction),
                       blue: CGFloat.evaluate(start: startColor.blue, end: endColor.blue, time: time, duration: duration, timingFunction: timingFunction),
                       alpha: CGFloat.evaluate(start: startColor.alpha, end: endColor.alpha, time: time, duration: duration, timingFunction: timingFunction))
    }
}

