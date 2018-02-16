
public class Operation<T>: Equatable where T: Tweenable {
    
    public typealias UpdateBlock = (_ period: Period<T>) -> ()
    public typealias CompleteBlock = () -> ()
    
    internal(set) public var expired: Bool = false
	private(set) public var period: Period<T>
	private(set) public var timingFunction: TimingFunction
	private(set) public var updateBlock: UpdateBlock?
	private(set) public var completeBlock: CompleteBlock?

	private(set) public var name: String?

	private(set) public var dispatchQueue: DispatchQueue?
    
	public init(name: String? = nil, period: Period<T>, updateBlock: UpdateBlock? = nil, completeBlock: CompleteBlock? = nil, timingFunction: @escaping TimingFunction = Timing.Linear, dispatchQueue: DispatchQueue? = DispatchQueue.main) {
		
		self.name = name
		self.period = period
		self.timingFunction = timingFunction
		self.updateBlock = updateBlock
		self.completeBlock = completeBlock
		self.dispatchQueue = dispatchQueue
	}
	
	public func reverse() {
		
		let start = self.period.start
		let end = self.period.end
		
		let timePassed = self.period.timePassed()
		
		self.period.set(end: end)
		self.period.set(start: start)
		
		if let updatedTimeStamp = self.period.updatedTimeStamp {
			
            self.period.set(startTimeStamp: updatedTimeStamp - (self.period.duration - timePassed + self.period.delay))
		}
	}
	
	public func tweenValues(_ numberOfIntervals: UInt) -> [T] {
		
		var tweenValues = [T]()
		
		for i in 1...Int(numberOfIntervals) {
			
			let time = TimeInterval(i) / TimeInterval(numberOfIntervals)
			
            let progress = T.evaluate(start: self.period.start,
                                      end: self.period.end,
                                      time: time,
                                      duration: self.period.duration,
                                      timingFunction: self.timingFunction)
            
            tweenValues.append(progress)
		}
		
		return tweenValues
	}
    
    public static func == (a: Operation<T>, b: Operation<T>) -> Bool {
        return a === b
    }
    
    public static func != (a: Operation<T>, b: Operation<T>) -> Bool {
        return !(a == b)
    }
    
    //Public Setters
    
    public func set(name: String) -> Operation<T> {
        
        self.name = name
        return self
    }
    
    public func set(delay: TimeInterval) -> Operation<T> {
        
        self.period.set(delay: delay)
        return self
    }
    
    public func set(timingFunction: @escaping TimingFunction) -> Operation<T> {
        
        self.timingFunction = timingFunction
        return self
    }
    
    public func set(update block: @escaping UpdateBlock) -> Operation<T> {
        
        self.updateBlock = block
        return self
    }
    
    public func set(complete block: @escaping CompleteBlock) -> Operation<T> {
        
        self.completeBlock = block
        return self
    }
}


