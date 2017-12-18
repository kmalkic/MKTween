//
//  MKTweenPeriod.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

open class MKTweenPeriod<T: BinaryFloatingPoint> {
	
	open let duration: TimeInterval
	private(set) open var delay: TimeInterval
	private(set) open var startValue: T
	private(set) open var endValue: T
	internal(set) open var progress: T = 0
	
	private(set) var startTimeStamp: TimeInterval?
	internal var updatedTimeStamp: TimeInterval?
	
    public init(duration: TimeInterval, delay: TimeInterval = 0.0, startValue: T = 0, endValue: T = 1) {
		
		self.duration = duration
		self.delay = delay
		self.startValue = startValue
		self.endValue = endValue
	}
    
    public func setStartTimeStamp(_ startTimeStamp: TimeInterval) {
        
        self.startTimeStamp = startTimeStamp
    }
    
    public func setStartValue(_ startValue: T) {
        
        self.startValue = startValue
    }
    
    public func setEndValue(_ endValue: T) {
        
        self.endValue = endValue
    }
    
    public func setDelay(_ delay: TimeInterval) {
        
        self.delay = delay
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
