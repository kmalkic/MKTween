//
//  MKTweenPeriod.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

open class MKTweenPeriod<T: BinaryFloatingPoint> {
	
	open let duration: TimeInterval
	open let delay: TimeInterval
	internal(set) open var startValue: T
	internal(set) open var endValue: T
	internal(set) open var progress: T = 0
	
	internal var startTimeStamp: TimeInterval?
	internal var updatedTimeStamp: TimeInterval?
	
    public init(duration: TimeInterval, delay: TimeInterval = 0.0, startValue: T = 0, endValue: T = 1) {
		
		self.duration = duration
		self.delay = delay
		self.startValue = startValue
		self.endValue = endValue
	}
}
