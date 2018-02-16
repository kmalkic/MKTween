
public enum TimerStyle : Int {
    
    case `default` //DisplayLink
    case displayLink
    case timer
    case none
}

public class Tween: NSObject {
    
    fileprivate var tweenOperations = [TweenableOperation]()
    fileprivate var pausedTimeStamp : TimeInterval?
    fileprivate var displayLink : CADisplayLink?
    fileprivate var timer: Timer?
    fileprivate var busy = false
    
    public var timerStyle: TimerStyle = .default {
        didSet {
            stop()
            start()
        }
    }
    
    /* When true the object is prevented from firing. Initial state is
    * false. */
    
    public var paused: Bool = false {
        didSet {
            pause()
        }
    }
    
    /* Defines how many display frames must pass between each time the
    * display link fires. Default value is one, which means the display
    * link will fire for every display frame. Setting the interval to two
    * will cause the display link to fire every other display frame, and
    * so on. The behavior when using values less than one is undefined. */
    
    public var frameInterval: Int = 1 {
        didSet {
            stop()
            start()
        }
    }
    
    public var timerInterval: TimeInterval = 1/60 {
        didSet {
            stop()
            start()
        }
    }
    
    deinit {
        stop()
    }
    
    public static let shared = Tween(.default)
    
    public class func shared(_ timerStyle: TimerStyle = .default, frameInterval: Int? = nil, timerInterval: TimeInterval? = nil) -> Tween {
        return Tween(timerStyle, frameInterval: frameInterval, timerInterval: timerInterval)
    }
    
    public init( _ timerStyle: TimerStyle = .default, frameInterval: Int? = nil, timerInterval: TimeInterval? = nil) {
        super.init()
        self.timerStyle = timerStyle
        self.frameInterval = frameInterval ?? self.frameInterval
        self.timerInterval = timerInterval ?? self.timerInterval
    }
    
    public func addTweenOperation<T>(_ operation: Operation<T>) {
        
        guard let tweenableOperation = TweenableMapper.map(operation),
            operation.period.duration > 0 else {
            print("please set a duration")
            return
        }
        
        self.tweenOperations.append(tweenableOperation)
        start()
    }
    
    public func removeTweenOperation<T>(_ operation: Operation<T>) -> Bool {
        
        guard let index = self.tweenOperations.index(where: {
            switch $0 {
            case let .cgfloat(op):
                return op == operation as? Operation<CGFloat>
            case let .float(op):
                return op == operation as? Operation<Float>
            case let .double(op):
                return op == operation as? Operation<Double>
            }
        })
            else { return false }
        
        self.tweenOperations.remove(at: index)
        return true
    }
    
    public func removeTweenOperationByName(_ name: String) -> Bool {
        
        let copy = self.tweenOperations
        
        for tweenableOperation in copy {
            
            switch tweenableOperation {
            case let .cgfloat(operation) where operation.name == name:
                return removeTweenOperation(operation)
            case let .float(operation) where operation.name == name:
                return removeTweenOperation(operation)
            case let .double(operation) where operation.name == name:
                return removeTweenOperation(operation)
            default:
                break
            }
        }
        return false
    }
    
    public func removeAllOperations() {
        
        self.tweenOperations.removeAll()
    }
    
    public func hasOperations() -> Bool {
        
        return self.tweenOperations.count > 0
    }
    
    fileprivate func progressOperation<T>(_ timeStamp: TimeInterval, operation: Operation<T>) {
        
        let period = operation.period
        
        guard let startTimeStamp = period.startTimeStamp else {
            period.change(startTimeStamp: timeStamp)
            return
        }
            
        guard period.hasStarted(timeStamp)
            else { return }
            
        if !period.hasEnded(timeStamp) {
            
            let progress = T.evaluate(start: period.start,
                                      end: period.end,
                                      time: timeStamp - startTimeStamp - period.delay,
                                      duration: period.duration,
                                      timingFunction: operation.timingFunction)
            
            period.progress = progress
            
        } else {
            
            period.progress = period.end
            
            operation.expired = true
        }
        
        period.updatedTimeStamp = timeStamp
        
        guard let updateBlock = operation.updateBlock
            else { return }
        
        if let dispatchQueue = operation.dispatchQueue {
            
            dispatchQueue.async(execute: { () -> Void in
                
                updateBlock(period)
            })
            
        } else {
            
            updateBlock(period)
        }
    }
    
    fileprivate func expiryOperation<T>(_ operation: Operation<T>) -> Operation<T> {
        
        if let completeBlock = operation.completeBlock {
            
            if let dispatchQueue = operation.dispatchQueue {
                
                dispatchQueue.async(execute: { () -> Void in
                    
                    completeBlock()
                })
                
            } else {
                
                completeBlock()
            }
        }
        
        return operation
    }
    
    public func update(_ timeStamp: TimeInterval) {
        
        guard hasOperations() else {
            stop()
            return
        }
    
        self.tweenOperations.forEach {
            switch $0 {
            case let .cgfloat(operation):
                progressOperation(timeStamp, operation: operation)
            case let .float(operation):
                progressOperation(timeStamp, operation: operation)
            case let .double(operation):
                progressOperation(timeStamp, operation: operation)
            }
        }
        
        let copy = self.tweenOperations
        
        copy.forEach {
            switch $0 {
            case let .cgfloat(operation) where operation.expired:
                _ = removeTweenOperation(operation)
            case let .float(operation) where operation.expired:
                _ = removeTweenOperation(operation)
            case let .double(operation) where operation.expired:
                _ = removeTweenOperation(operation)
            default:
                break
            }
        }
    }
    
    @objc func handleDisplayLink(_ sender: CADisplayLink) {
        
        handleTick(sender.timestamp)
    }
    
    @objc func handleTimer(_ sender: Timer) {
        
        handleTick(CACurrentMediaTime())
    }
    
    fileprivate func handleTick(_ timeStamp: TimeInterval) {
        
        if self.busy {
            
            return
        }
        
        self.busy = true
        
        update(timeStamp)
        
        self.busy = false
    }
    
    fileprivate func start() {
        
        if self.tweenOperations.count == 0 || self.paused {
            
            return
        }
        
        if self.displayLink == nil && (self.timerStyle == .default || self.timerStyle == .displayLink) {
            
            self.displayLink = UIScreen.main.displayLink(withTarget: self, selector: #selector(Tween.handleDisplayLink(_:)))
            self.displayLink!.frameInterval = self.frameInterval
            self.displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            
        } else if timer == nil && timerStyle == .timer {
            
            self.timer = Timer.scheduledTimer(timeInterval: self.timerInterval, target: self, selector: #selector(Tween.handleTimer(_:)), userInfo: nil, repeats: true)
            self.timer!.fire()
        }
    }
    
    fileprivate func stop() {
        
        if self.displayLink != nil {
            
            self.displayLink!.isPaused = true
            self.displayLink!.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
            self.displayLink = nil
        }
        
        if self.timer != nil {
            
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    fileprivate func pause() {
        
        if self.paused && (self.timer != nil || self.displayLink != nil) {
            
            self.pausedTimeStamp = CACurrentMediaTime()
            stop()
            return
        }
        
        guard self.timer == nil && self.displayLink == nil
            else { return }
        
        guard let pausedTimeStamp = self.pausedTimeStamp else {
            
            self.pausedTimeStamp = nil
            start()
            return
        }
        
        let diff = CACurrentMediaTime() - pausedTimeStamp
        
        func pause<T>(_ operation: Operation<T>, time: TimeInterval) {
            
            if let startTimeStamp = operation.period.startTimeStamp {
                
                operation.period.change(startTimeStamp: startTimeStamp + time)
            }
        }
        
        self.tweenOperations.forEach {
            switch $0 {
            case let .cgfloat(operation):
                pause(operation, time: diff)
            case let .float(operation):
                pause(operation, time: diff)
            case let .double(operation):
                pause(operation, time: diff)
            }
        }
    }
    
    //Convience functions
    
    public func value<T: BinaryFloatingPoint>(duration: TimeInterval, start: T = 0, end: T = 1) -> Operation<T> {
    
        let period = Period(duration: duration, delay: 0, start: start, end: end)
        
        let operation = Operation(period: period)
        
        addTweenOperation(operation)
        
        return operation
    }
}
