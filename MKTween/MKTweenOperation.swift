//
//  MKTweenOperation.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

public typealias MKTweenUpdateBlock = (_ period: MKTweenPeriod) -> ()
public typealias MKTweenCompleteBlock = () -> ()

open class MKTweenOperation: Equatable {
	
	internal(set) open var period: MKTweenPeriod
	open let timingFunction: MKTweenTimingFunction
	let updateBlock: MKTweenUpdateBlock?
	let completeBlock: MKTweenCompleteBlock?

	let name: String?

	let dispatchQueue: DispatchQueue?
	
	public init(name: String? = nil, period: MKTweenPeriod, updateBlock: MKTweenUpdateBlock? = nil, completeBlock: MKTweenCompleteBlock? = nil, timingFunction: @escaping MKTweenTimingFunction = MKTweenTiming.Linear, dispatchQueue: DispatchQueue? = DispatchQueue.main) {
		
		self.name = name
		self.period = period
		self.timingFunction = timingFunction
		self.updateBlock = updateBlock
		self.completeBlock = completeBlock
		self.dispatchQueue = dispatchQueue
	}
	
	open func reverse() {
		
		let startValue = period.startValue
		let endValue = period.endValue
		
		let timeDone = (period.progress > 0) ? (period.duration * period.progress) / endValue : 0
		
		period.startValue = endValue
		period.endValue = startValue
		
		if let updatedTimeStamp = period.updatedTimeStamp {
			
			period.startTimeStamp = updatedTimeStamp - (period.duration - timeDone + period.delay)
		}
	}
	
	open func tweenValues(_ numberOfIntervals: UInt) -> [Double] {
		
		var tweenValues = [Double]()
		
		for i in 1...Int(numberOfIntervals) {
			
			let time: Double = Double(i) / Double(numberOfIntervals)
			
			let progress = timingFunction(time, period.startValue, period.endValue - period.startValue, period.duration)
			
			tweenValues.append(progress)
		}
		
		return tweenValues
	}
}

public func == (a: MKTweenOperation, b: MKTweenOperation) -> Bool {
    
    return a === b
}
