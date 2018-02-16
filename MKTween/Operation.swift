//
//  Operation.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

open class Operation<T>: Equatable where T: BinaryFloatingPoint {
    
    public typealias UpdateBlock = (_ period: Period<T>) -> ()
    public typealias CompleteBlock = () -> ()
    
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
	
	open func reverse() {
		
		let startValue = self.period.startValue
		let endValue = self.period.endValue
		
		let timeDone = (self.period.duration * TimeInterval(self.period.progress)) / TimeInterval(endValue)
		
		self.period.setStartValue(endValue)
		self.period.setEndValue(startValue)
		
		if let updatedTimeStamp = self.period.updatedTimeStamp {
			
			self.period.setStartTimeStamp(updatedTimeStamp - (self.period.duration - timeDone + self.period.delay))
		}
	}
	
	open func tweenValues(_ numberOfIntervals: UInt) -> [T] {
		
		var tweenValues = [T]()
		
		for i in 1...Int(numberOfIntervals) {
			
			let time: T = T(i) / T(numberOfIntervals)
			
            let progress = self.timingFunction(time.toDouble(), self.period.startValue.toDouble(), self.period.endValue.toDouble() - self.period.startValue.toDouble(), self.period.duration)
            
            let value = T(progress)
            
            tweenValues.append(value)
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
    
    public func setName(_ name: String) -> Operation<T> {
        
        self.name = name
        
        return self
    }
    
    public func setDelay(_ delay: TimeInterval) -> Operation<T> {
        
        self.period.setDelay(delay)
        
        return self
    }
    
    public func setTimingFunction(_ timingFunction: @escaping TimingFunction) -> Operation<T> {
        
        self.timingFunction = timingFunction
        
        return self
    }
    
    public func setUpdateBlock(_ updateBlock: @escaping UpdateBlock) -> Operation<T> {
        
        self.updateBlock = updateBlock
        
        return self
    }
    
    public func setCompleteBlock(_ completeBlock: @escaping CompleteBlock) -> Operation<T> {
        
        self.completeBlock = completeBlock
        
        return self
    }
}


