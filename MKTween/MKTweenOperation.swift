//
//  MKTweenOperation.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

public typealias MKTweenUpdateBlock = (period: MKTweenPeriod) -> ()
public typealias MKTweenCompleteBlock = () -> ()

public class MKTweenOperation: Equatable {
	
	internal(set) public var period: MKTweenPeriod
	public let timingFunction: MKTweenTimingFunction
	let updateBlock: MKTweenUpdateBlock?
	let completeBlock: MKTweenCompleteBlock?
	let dispatchQueue: dispatch_queue_t?
	
	public init(period: MKTweenPeriod, updateBlock: MKTweenUpdateBlock? = nil, completeBlock: MKTweenCompleteBlock? = nil, timingFunction: MKTweenTimingFunction = MKTweenTiming.Linear, dispatchQueue: dispatch_queue_t? = dispatch_get_main_queue()) {
		
		self.period = period
		self.timingFunction = timingFunction
		self.updateBlock = updateBlock
		self.completeBlock = completeBlock
		self.dispatchQueue = dispatchQueue
	}
	
	public func reverse() {
		
		let startValue = period.startValue
		let endValue = period.endValue
		
		let timeDone = (period.progress > 0) ? (period.duration * period.progress) / endValue : 0
		
		period.startValue = endValue
		period.endValue = startValue
		
		if let updatedTimeStamp = period.updatedTimeStamp {
			
			period.startTimeStamp = updatedTimeStamp - (period.duration - timeDone + period.delay)
		}
	}
	
	public func tweenValues(numberOfIntervals: UInt) -> [Double] {
		
		var tweenValues = [Double]()
		
		for i in 1...Int(numberOfIntervals) {
			
			let time: Double = Double(i) / Double(numberOfIntervals)
			
			let progress = timingFunction(time: time, begin: period.startValue, difference: period.endValue - period.startValue, duration: period.duration)
			
			tweenValues.append(progress)
		}
		
		return tweenValues
	}
}

public func == (a: MKTweenOperation, b: MKTweenOperation) -> Bool {
	
	return a.dynamicType.self === b.dynamicType.self
}