//
//  MKTweenOperation.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

open class MKTweenOperation<T>: Equatable where T: BinaryFloatingPoint {
    
    public typealias MKTweenUpdateBlock = (_ period: MKTweenPeriod<T>) -> ()
    public typealias MKTweenCompleteBlock = () -> ()
    
	private(set) public var period: MKTweenPeriod<T>
	private(set) public var timingFunction: MKTweenTimingFunction
	private(set) public var updateBlock: MKTweenUpdateBlock?
	private(set) public var completeBlock: MKTweenCompleteBlock?

	private(set) public var name: String?

	private(set) public var dispatchQueue: DispatchQueue?
    
	public init(name: String? = nil, period: MKTweenPeriod<T>, updateBlock: MKTweenUpdateBlock? = nil, completeBlock: MKTweenCompleteBlock? = nil, timingFunction: @escaping MKTweenTimingFunction = MKTweenTiming.Linear, dispatchQueue: DispatchQueue? = DispatchQueue.main) {
		
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
    
    public static func == (a: MKTweenOperation<T>, b: MKTweenOperation<T>) -> Bool {
        
        return a === b
    }
    
    public static func != (a: MKTweenOperation<T>, b: MKTweenOperation<T>) -> Bool {
        
        return !(a == b)
    }
    
    //Public Setters
    
    public func setName(_ name: String) -> MKTweenOperation<T> {
        
        self.name = name
        
        return self
    }
    
    public func setDelay(_ delay: TimeInterval) -> MKTweenOperation<T> {
        
        self.period.setDelay(delay)
        
        return self
    }
    
    public func setTimingFunction(_ timingFunction: @escaping MKTweenTimingFunction) -> MKTweenOperation<T> {
        
        self.timingFunction = timingFunction
        
        return self
    }
    
    public func setUpdateBlock(_ updateBlock: @escaping MKTweenUpdateBlock) -> MKTweenOperation<T> {
        
        self.updateBlock = updateBlock
        
        return self
    }
    
    public func setCompleteBlock(_ completeBlock: @escaping MKTweenCompleteBlock) -> MKTweenOperation<T> {
        
        self.completeBlock = completeBlock
        
        return self
    }
}


