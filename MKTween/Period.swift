
public class Period<T> where T: Tweenable {
	
	public let duration: TimeInterval
	private(set) public var delay: TimeInterval
	private(set) public var start: T
	private(set) public var end: T
	internal(set) public var progress: T = T.defaultValue()
	
	private(set) var startTimeStamp: TimeInterval?
	internal var updatedTimeStamp: TimeInterval?
	
    public init(start: T, end: T, duration: TimeInterval = 1, delay: TimeInterval = 0.0) {
		
		self.duration = duration
		self.delay = delay
		self.start = start
		self.end = end
	}
    
    internal func set(startTimeStamp: TimeInterval) {
        self.startTimeStamp = startTimeStamp
    }
    
    public func set(start: T) {
        self.start = start
    }
    
    public func set(end: T) {
        self.end = end
    }
    
    public func set(delay: TimeInterval) {
        self.delay = delay
    }
    
    public func timePassed() -> TimeInterval {
        guard let startTimeStamp = self.startTimeStamp,
            let updatedTimeStamp = self.updatedTimeStamp
            else { return 0 }
        
        return updatedTimeStamp - startTimeStamp
    }
    
    public func hasStarted(_ timeStamp: TimeInterval) -> Bool {
        
        guard let startTimeStamp = self.startTimeStamp
            else { return false }
        
        let timeToStart = startTimeStamp + self.delay
        return timeStamp >= timeToStart
    }
    
    public func hasEnded(_ timeStamp: TimeInterval) -> Bool {
        
        guard let startTimeStamp = self.startTimeStamp
            else { return false }
            
        let timeToEnd = startTimeStamp + self.delay + self.duration
        return timeStamp >= timeToEnd
    }
}
