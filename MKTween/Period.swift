//
//  Period.swift
//  MKTween
//
//  Created by Kevin Malkic on 08/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

public enum RepeatType {
    case once
    case pingPong
    case forever
    case foreverPingPong
}

public class TweenDirection {
    
    public static let forward = TweenDirection(1)
    public static let backward = TweenDirection(-1)
    
    public let value: Double
    
    private init(_ value: Double) {
        self.value = value
    }
    
    public func reverse() -> TweenDirection {
        if value == TweenDirection.forward.value {
            return TweenDirection.backward
        }
        return TweenDirection.forward
    }
}

public final class Period<T> : BasePeriod where T: Tweenable {
    
    public typealias UpdateBlock = (_ period: Period<T>) -> ()
    public typealias CompletionBlock = () -> ()
    
    private(set) public var update: UpdateBlock?
    private(set) public var completion: CompletionBlock?
    
    private(set) public var name: String = UUID().uuidString
    
	public let duration: TimeInterval
	private(set) public var delay: TimeInterval
	private(set) public var start: T
	private(set) public var end: T
    private(set) public var timingMode: Timing
    
	private(set) public var startTimestamp: TimeInterval
    private(set) public var lastTimestamp: TimeInterval
    private(set) public var timePassed: TimeInterval = 0
    private(set) public var paused: Bool = false
    
    internal(set) public var progress: T = T.defaultValue()
    
    private var didFinish = false
    private var direction: TweenDirection
    private(set) public var repeatType: RepeatType
    private(set) public var repeatCount: Int
    
    public init(start: T, end: T, duration: TimeInterval = 1, delay: TimeInterval = 0.0, timingMode: Timing = .linear) {
        let time = Date().timeIntervalSinceReferenceDate
        self.startTimestamp = time
        self.lastTimestamp = time
		self.duration = duration
		self.delay = delay
		self.start = start
		self.end = end
        self.timingMode = timingMode
        self.direction = .forward
        self.repeatType = .once
        self.repeatCount = 1
	}
    
    public func updateInternal() -> Bool {
        if didFinish {
            return true
        }
        
        let newTime = Date().timeIntervalSinceReferenceDate
        var dt = lastTimestamp.deltaTime(from: newTime)
        lastTimestamp = newTime
        
        if delay <= 0 && !paused {
            dt = dt * direction.value
            timePassed += dt
            timePassed = timePassed.clamped(to: 0...duration)
            
            progress = T.evaluate(start: start,
                                   end: end,
                                   time: timePassed,
                                   duration: duration,
                                   timingFunction: timingMode.timingFunction())

            didFinish = direction.value == TweenDirection.forward.value ? timePassed >= duration : timePassed <= 0
            
            if (didFinish) {
                switch repeatType {
                case .forever:
                    timePassed = 0
                case .foreverPingPong:
                    direction = direction.reverse()
                case .pingPong:
                    direction = direction.reverse()
                    repeatCount -= 1
                default:
                    timePassed = 0
                    repeatCount -= 1
                }
                didFinish = repeatCount == 0 || repeatType == .once
            }
            return didFinish
            
        } else if !paused {
            delay -= dt;
        }
        
        return false
    }
    
    public func reverse() {
        let start = self.end
        let end = self.start

        self.start = end
        self.end = start
        
        set(startTimestamp: lastTimestamp - (duration - timePassed + delay))
    }
    
    public func tweenValues(_ numberOfIntervals: UInt) -> [T] {
        let tweenValues = stride(from: 1, through: Int(numberOfIntervals), by: 1).map { (i) -> T in
            T.evaluate(start: start,
                       end: end,
                       time: TimeInterval(i) / TimeInterval(numberOfIntervals),
                       duration: duration,
                       timingFunction: timingMode.timingFunction())
        }
        return tweenValues
    }

    public func callUpdateBlock() {
        update?(self)
    }
    
    public func callCompletionBlock() {
        completion?()
    }
    
    public func pause() {
        paused = true
    }
    
    public func resume() {
        paused = false
    }
    
    public func set(startTimestamp time: TimeInterval) {
        self.startTimestamp = time
        self.lastTimestamp = time
    }
    
    @discardableResult public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    @discardableResult public func set(update: UpdateBlock? = nil, completion: CompletionBlock? = nil) -> Period<T> {
        self.update = update
        self.completion = completion
        return self
    }
    
    @discardableResult public func set(timingMode: Timing) -> Period<T> {
        self.timingMode = timingMode
        return self
    }
    
    @discardableResult public func set(repeatType: RepeatType) -> Period<T> {
        self.repeatType = repeatType
        switch repeatType {
        case .forever:
            repeatCount = -1
        case .foreverPingPong:
            repeatCount = -1
        case .pingPong:
            repeatCount *= 2
        case .once:
            self.repeatCount = 1
        }
        return self
    }
    
    @discardableResult public func set(repeatCount: Int) -> Period<T> {
        self.repeatCount = repeatCount
        if repeatCount == -1 {
            repeatType = .forever
        }
        switch repeatType {
        case .pingPong:
            self.repeatCount *= 2
        case .once:
            self.repeatCount = 1
        default:
            break
        }
        return self
    }
}
