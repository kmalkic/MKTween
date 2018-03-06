
public class OperationTween<T>: Equatable where T: Tweenable {
    
    public typealias UpdateBlock = (_ period: Period<T>) -> ()
    public typealias CompleteBlock = () -> ()
    
    internal(set) public var expired: Bool = false
	private(set) public var period: Period<T>
	private(set) public var timingMode: Timing
	private(set) public var updateBlock: UpdateBlock?
	private(set) public var completeBlock: CompleteBlock?

	private(set) public var name: String?

	private(set) public var dispatchQueue: DispatchQueue?
    
	public init(name: String? = nil,
                period: Period<T>,
                updateBlock: UpdateBlock? = nil,
                completeBlock: CompleteBlock? = nil,
                timingMode: Timing = .linear,
                dispatchQueue: DispatchQueue? = DispatchQueue.main) {
		
		self.name = name
		self.period = period
		self.timingMode = timingMode
		self.updateBlock = updateBlock
		self.completeBlock = completeBlock
		self.dispatchQueue = dispatchQueue
	}
	
	public func reverse() {
		
		let start = self.period.start
		let end = self.period.end
		
		let timePassed = self.period.timePassed()

        self.expired = false
		self.period.set(end: end)
		self.period.set(start: start)
		
		if let updatedTimeStamp = self.period.updatedTimeStamp {
			
            self.period.set(startTimeStamp: updatedTimeStamp - (self.period.duration - timePassed + self.period.delay))
		}
	}
	
	public func tweenValues(_ numberOfIntervals: UInt) -> [T] {

        let tweenValues = stride(from: 1, through: Int(numberOfIntervals), by: 1).map { (i) -> T in
            T.evaluate(start: self.period.start,
                       end: self.period.end,
                       time: TimeInterval(i) / TimeInterval(numberOfIntervals),
                       duration: self.period.duration,
                       timingFunction: self.timingMode.timingFunction())
        }
		return tweenValues
	}
    
    public static func == (a: OperationTween<T>, b: OperationTween<T>) -> Bool {
        return a === b
    }
        
    //Public Setters
    
    public func set(name: String) -> OperationTween<T> {
        
        self.name = name
        return self
    }
    
    public func set(delay: TimeInterval) -> OperationTween<T> {
        
        self.period.set(delay: delay)
        return self
    }
    
    public func set(timingMode: Timing) -> OperationTween<T> {
        
        self.timingMode = timingMode
        return self
    }
    
    public func set(update block: @escaping UpdateBlock) -> OperationTween<T> {
        
        self.updateBlock = block
        return self
    }
    
    public func set(complete block: @escaping CompleteBlock) -> OperationTween<T> {
        
        self.completeBlock = block
        return self
    }
}


