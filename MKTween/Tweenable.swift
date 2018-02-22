
enum TweenableOperation {
    case double(Operation<Double>)
    case float(Operation<Float>)
    case cgfloat(Operation<CGFloat>)
    case cgsize(Operation<CGSize>)
    case cgpoint(Operation<CGPoint>)
    case cgrect(Operation<CGRect>)
}

public protocol Tweenable {
    
    static var defaultValue: Self { get }
    static func evaluate(start: Self, end: Self, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Self
}

class TweenableMapper {
    
    static func map<T>(_ operation: Operation<T>) -> TweenableOperation? {
        
        if let operation = operation as? Operation<Double> {
            return .double(operation)
        } else if let operation = operation as? Operation<Float> {
            return .float(operation)
        } else if let operation = operation as? Operation<CGFloat> {
            return .cgfloat(operation)
        } else if let operation = operation as? Operation<CGSize> {
            return .cgsize(operation)
        } else if let operation = operation as? Operation<CGPoint> {
            return .cgpoint(operation)
        } else if let operation = operation as? Operation<CGRect> {
            return .cgrect(operation)
        }
        print("Tweenable not mapped yet")
        return nil
    }
}


extension Double: Tweenable {
    
    public static var defaultValue: Double {
        return 0.0
    }
    
    public static func evaluate(start: Double, end: Double, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Double {
        return timingFunction(time, start, end - start, duration)
    }
}

extension Float: Tweenable {
    
    public static var defaultValue: Float {
        return 0.0
    }
    
    public static func evaluate(start: Float, end: Float, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Float {
        return Float(timingFunction(time, Double(start), Double(end - start), duration))
    }
}

extension CGFloat: Tweenable {
    
    public static var defaultValue: CGFloat {
        return 0.0
    }
    
    public static func evaluate(start: CGFloat, end: CGFloat, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGFloat {
        return CGFloat(timingFunction(time, Double(start), Double(end - start), duration))
    }
}

extension CGSize: Tweenable {
    
    public static var defaultValue: CGSize {
        return .zero
    }
    
    public static func evaluate(start: CGSize, end: CGSize, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGSize {
        return CGSize(width: CGFloat.evaluate(start: start.width, end: end.width, time: time, duration: duration, timingFunction: timingFunction),
                      height: CGFloat.evaluate(start: start.height, end: end.height, time: time, duration: duration, timingFunction: timingFunction))
    }
}

extension CGPoint: Tweenable {
    
    public static var defaultValue: CGPoint {
        return .zero
    }
    
    public static func evaluate(start: CGPoint, end: CGPoint, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGPoint {
        return CGPoint(x: CGFloat.evaluate(start: start.x, end: end.x, time: time, duration: duration, timingFunction: timingFunction),
                       y: CGFloat.evaluate(start: start.y, end: end.y, time: time, duration: duration, timingFunction: timingFunction))
    }
}

extension CGRect: Tweenable {
    
    public static var defaultValue: CGRect {
        return .zero
    }
    
    public static func evaluate(start: CGRect, end: CGRect, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGRect {
        return CGRect(origin: CGPoint.evaluate(start: start.origin, end: end.origin, time: time, duration: duration, timingFunction: timingFunction),
                      size: CGSize.evaluate(start: start.size, end: end.size, time: time, duration: duration, timingFunction: timingFunction))
    }
}

