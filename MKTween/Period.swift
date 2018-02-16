
public class Period<T> where T: Tweenable {
	
	public let duration: TimeInterval
	private(set) public var delay: TimeInterval
	private(set) public var start: T
	private(set) public var end: T
	internal(set) public var progress: T = T.defaultValue
	
	private(set) var startTimeStamp: TimeInterval?
	internal var updatedTimeStamp: TimeInterval?
	
    public init(duration: TimeInterval, delay: TimeInterval = 0.0, start: T, end: T) {
		
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
        return self.duration * T.progression(start: self.start, progress: self.progress, end: self.end)
    }
    
    public func hasStarted(_ timeStamp: TimeInterval) -> Bool {
        
        if let startTimeStamp = self.startTimeStamp {
            
            let timeToStart = startTimeStamp + self.delay
            return timeStamp >= timeToStart
        }
        return false
    }
    
    public func hasEnded(_ timeStamp: TimeInterval) -> Bool {
        
        if let startTimeStamp = self.startTimeStamp {
            
            let timeToEnd = startTimeStamp + self.delay + self.duration
            return timeStamp >= timeToEnd
        }
        return false
    }
}
