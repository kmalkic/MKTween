//
//  MKTweenPeriod.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

public class MKTweenPeriod {
	
	public let duration: NSTimeInterval
	public let delay: NSTimeInterval
	internal(set) public var startValue: Double
	internal(set) public var endValue: Double
	internal(set) public var progress: Double = 0
	
	internal var startTimeStamp: NSTimeInterval?
	internal var updatedTimeStamp: NSTimeInterval?
	
	public init(duration: NSTimeInterval, delay: NSTimeInterval = 0, startValue: Double = 0, endValue: Double = 1) {
		
		self.duration = duration
		self.delay = delay
		self.startValue = startValue
		self.endValue = endValue
	}
}
