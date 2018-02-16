
enum TweenableOperation {
    case cgfloat(Operation<CGFloat>)
    case float(Operation<Float>)
    case double(Operation<Double>)
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
        } else if let operation = operation as? Operation<CGFloat> {
            return .cgfloat(operation)
        } else if let operation = operation as? Operation<Float> {
            return .float(operation)
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

extension CGRect: Tweenable {
    
    public static var defaultValue: CGRect {
        return .zero
    }
    
    public static func evaluate(start: CGRect, end: CGRect, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGRect {
        return CGRect(x: CGFloat(timingFunction(time, Double(start.origin.x), Double(end.origin.x - start.origin.x), duration)),
                      y: CGFloat(timingFunction(time, Double(start.origin.y), Double(end.origin.y - start.origin.y), duration)),
                      width: CGFloat(timingFunction(time, Double(start.size.width), Double(end.size.width - start.size.width), duration)),
                      height: CGFloat(timingFunction(time, Double(start.size.height), Double(end.size.height - start.size.height), duration)))
    }
}

