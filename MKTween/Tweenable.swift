
enum TweenableOperation {
    case cgfloat(Operation<CGFloat>)
    case float(Operation<Float>)
    case double(Operation<Double>)
}

public protocol Tweenable {
    
    static var defaultValue: Self { get }
    static func evaluate(start: Self, end: Self, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Self
    static func progression(start: Self, progress: Self, end: Self) -> Double
}

class TweenableMapper {
    
    static func map<T>(_ operation: Operation<T>) -> TweenableOperation? {
        
        if let operation = operation as? Operation<Double> {
            return .double(operation)
        } else if let operation = operation as? Operation<CGFloat> {
            return .cgfloat(operation)
        } else if let operation = operation as? Operation<Float> {
            return .float(operation)
        }
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

    public static func progression(start: Double, progress: Double, end: Double) -> Double {
        return progress / (end - start)
    }
}

extension Float: Tweenable {

    public static var defaultValue: Float {
        return 0.0
    }
    
    public static func evaluate(start: Float, end: Float, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> Float {
        return Float(timingFunction(time, Double(start), Double(end - start), duration))
    }
    
    public static func progression(start: Float, progress: Float, end: Float) -> Double {
        return Double(progress / (end - start))
    }
}

extension CGFloat: Tweenable {

    public static var defaultValue: CGFloat {
        return 0.0
    }
    
    public static func evaluate(start: CGFloat, end: CGFloat, time: TimeInterval, duration: TimeInterval, timingFunction: TimingFunction) -> CGFloat {
        return CGFloat(timingFunction(time, Double(start), Double(end - start), duration))
    }
    
    public static func progression(start: CGFloat, progress: CGFloat, end: CGFloat) -> Double {
        return Double(progress / (end - start))
    }
}
