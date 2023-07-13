//
//  Group.swift
//  MKTween
//
//  Created by Kevin Malkic on 08/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import Foundation

public final class Group: BasePeriods {
    
    public typealias UpdateBlock = (_ group: Group) -> ()
    public typealias CompletionBlock = () -> ()
    
    private(set) public var update: UpdateBlock?
    private(set) public var completion: CompletionBlock?
    private(set) public var cancelled: CompletionBlock?
    
    private(set) public var name: String = UUID().uuidString
    private(set) public var periodFinished: [Bool]
    public let periods: [BasePeriod]
    
    public let startTimestamp: TimeInterval
    private(set) public var lastTimestamp: TimeInterval
    
    public var delay: TimeInterval
    public var duration: TimeInterval {
        return periods.reduce(0) { (prev, period) -> TimeInterval in
            max(prev, period.duration + period.delay)
            } + delay
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
        self.periodFinished = Array(repeating: false, count: periods.count)
    }
    
    public func updateInternal() -> Bool {
        if delay <= 0 && !paused {
            periods.enumerated().forEach { index, period in
                if !periodFinished[index] && period.updateInternal() {
                    periodFinished[index] = true
                }
            }
            return periodFinished.filter { !$0 }.isEmpty
            
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
    
    @discardableResult public func set(update: UpdateBlock? = nil, completion: CompletionBlock? = nil) -> Group {
        self.update = update
        self.completion = completion
        return self
    }

    @discardableResult public func set(cancelled: CompletionBlock? = nil) -> Group {
        self.cancelled = cancelled
        return self
    }
}
