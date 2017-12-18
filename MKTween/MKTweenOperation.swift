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
    
	internal(set) open var period: MKTweenPeriod<T>
	open let timingFunction: MKTweenTimingFunction
	let updateBlock: MKTweenUpdateBlock?
	let completeBlock: MKTweenCompleteBlock?

	let name: String?

	let dispatchQueue: DispatchQueue?
	
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
		
		let timeDone = (self.period.progress > 0) ? (self.period.duration * TimeInterval(self.period.progress)) / TimeInterval(endValue) : 0
		
		self.period.startValue = endValue
		self.period.endValue = startValue
		
		if let updatedTimeStamp = self.period.updatedTimeStamp {
			
			self.period.startTimeStamp = updatedTimeStamp - (self.period.duration - timeDone + self.period.delay)
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
}


