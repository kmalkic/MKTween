//
//  Sequence.swift
//  MKTween
//
//  Created by Kevin Malkic on 08/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import Foundation

public final class Sequence: BasePeriods {
    
    public typealias UpdateBlock = (_ group: Sequence) -> ()
    public typealias CompletionBlock = () -> ()
    
    private(set) public var update: UpdateBlock?
    private(set) public var completion: CompletionBlock?
    private(set) public var cancelled: CompletionBlock?

    private(set) public var name: String = UUID().uuidString
    public let periods: [BasePeriod]
    private(set) public var currentPeriodIndex: Int = 0
    
    public let startTimestamp: TimeInterval
    private(set) public var lastTimestamp: TimeInterval
    
    public var delay: TimeInterval = 0
    public var duration: TimeInterval {
        return periods.reduce(delay, { (prev, period) -> TimeInterval in
            return prev + period.duration + period.delay
        })
    }
    
    public var paused: Bool {
        return periods.reduce(nil, { (prev, period) -> Bool in
            if let prev = prev {
                return prev && period.paused
            }
            return period.paused
        }) ?? false
    }
    
    public init(periods: [BasePeriod], delay: TimeInterval = 0) {
        self.delay = delay
        self.periods = periods
        let time = Date().timeIntervalSinceReferenceDate
        self.startTimestamp = time
        self.lastTimestamp = time
    }
    
    public func updateInternal() -> Bool {
        if delay <= 0 && !paused {
            let period = periods[currentPeriodIndex]
            if period.updateInternal() {
                currentPeriodIndex += 1
                if currentPeriodIndex == periods.count {
                    return true
                }
                periods[currentPeriodIndex].set(startTimestamp: Date().timeIntervalSinceReferenceDate)
            }
        } else if !paused {
            let newTime = Date().timeIntervalSinceReferenceDate
            let dt = lastTimestamp.deltaTime(from: newTime)
            lastTimestamp = newTime
            
            delay -= dt
        }
        return false
    }

    public func set(startTimestamp time: TimeInterval) {
        periods.forEach { $0.set(startTimestamp: time) }
    }
    
    @discardableResult public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func callUpdateBlock() {
        periods.forEach { $0.callUpdateBlock() }
        update?(self)
    }
    
    public func callCompletionBlock() {
        periods.forEach { $0.callCompletionBlock() }
        completion?()
    }

    public func callCancelledBlock() {
        periods.forEach { $0.callCancelledBlock() }
        cancelled?()
    }
    
    @discardableResult public func set(update: UpdateBlock? = nil, completion: CompletionBlock? = nil) -> Sequence {
        self.update = update
        self.completion = completion
        return self
    }

    @discardableResult public func set(cancelled: CompletionBlock? = nil) -> Sequence {
        self.cancelled = cancelled
        return self
    }
}
