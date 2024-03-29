//
//  Tween.swift
//  MKTween
//
//  Created by Kevin Malkic.
//  Copyright © 2024 Kevin Malkic. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

public enum TimerStyle : Int {
    
    case `default` //DisplayLink
    case displayLink
    case timer
    case none
}

public class Tween: NSObject {
    
    fileprivate var periods = [BasePeriod]()
    fileprivate var pausedTimeStamp : TimeInterval?
    fileprivate var displayLink : CADisplayLink?
    fileprivate var timer: Timer?
    fileprivate var busy = false
    fileprivate var dispatchQueue: DispatchQueue
    
    public var timerStyle: TimerStyle = .default {
        didSet {
            stop()
            start()
        }
    }
    
    /* When true the object is prevented from firing. Initial state is
     * false. */
    
    public var paused: Bool = false {
        didSet {
            pause()
        }
    }
    
    /* Defines how many display frames must pass between each time the
     * display link fires. Default value is one, which means the display
     * link will fire for every display frame. Setting the interval to two
     * will cause the display link to fire every other display frame, and
     * so on. The behavior when using values less than one is undefined. */
    
    public var preferredFramesPerSecond: Int = 60 {
        didSet {
            stop()
            start()
        }
    }
    
    public var timerInterval: TimeInterval = 1/60 {
        didSet {
            stop()
            start()
        }
    }
    
    deinit {
        stop()
    }
    
    public static let shared = Tween(.default)
    
    public class func shared(
        _ timerStyle: TimerStyle = .default,
        preferredFramesPerSecond: Int? = nil,
        timerInterval: TimeInterval? = nil,
        dispatchQueue: DispatchQueue = DispatchQueue.main
    ) -> Tween {
        return Tween(
            timerStyle,
            preferredFramesPerSecond: preferredFramesPerSecond,
            timerInterval: timerInterval,
            dispatchQueue: dispatchQueue
        )
    }
    
    public init(
        _ timerStyle: TimerStyle = .default,
        preferredFramesPerSecond: Int? = nil,
        timerInterval: TimeInterval? = nil,
        dispatchQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.dispatchQueue = dispatchQueue
        super.init()
        self.timerStyle = timerStyle
        self.preferredFramesPerSecond = preferredFramesPerSecond ?? self.preferredFramesPerSecond
        self.timerInterval = timerInterval ?? self.timerInterval
    }
    
    public func add(period: BasePeriod) {
        
        guard period.duration > 0 else {
            print("please set a duration")
            return
        }
        
        periods.append(period)
        start()
    }
    
    @discardableResult public func remove(
        period: BasePeriod,
        cancelled: Bool = true
    ) -> Bool {
        guard let index = periods.firstIndex(where: { findPeriod -> Bool in
            findPeriod.name == period.name
        }) else { return false }
        if cancelled {
            dispatchQueue.async { () -> Void in
                period.callCancelledBlock()
            }
        }
        periods.remove(at: index)
        return true
    }
    
    @discardableResult public func removePeriod(
        by name: String,
        cancelled: Bool = true
    ) -> Bool {
        guard let period = periods.first(where: { period -> Bool in
            period.name == name
        }) else { return false }
        return remove(period: period, cancelled: cancelled)
    }
    
    public func removeAll() {
        periods.removeAll()
    }
    
    public func hasPeriods() -> Bool {
        return periods.count > 0
    }
    
    public func update(_ timeStamp: TimeInterval) {
        
        guard hasPeriods() else {
            stop()
            return
        }
        
        var periodFinished = [BasePeriod]()
        
        periods.forEach { period in
            if period.updateInternal() {
                periodFinished.append(period)
            }
            dispatchQueue.async { () -> Void in
                period.callUpdateBlock()
            }
        }
        
        periodFinished.forEach { period in
            dispatchQueue.async { () -> Void in
                period.callCompletionBlock()
            }
            remove(period: period, cancelled: false)
        }
    }
    
    @objc func handleDisplayLink(_ sender: CADisplayLink) {
        handleTick(sender.timestamp)
    }
    
    @objc func handleTimer(_ sender: Timer) {
        handleTick(CACurrentMediaTime())
    }
    
    fileprivate func handleTick(_ timeStamp: TimeInterval) {
        
        guard !self.busy
        else { return }
        
        self.busy = true
        update(timeStamp)
        self.busy = false
    }
    
    fileprivate func start() {
        
        guard hasPeriods() && !self.paused
        else { return }
        
        if self.displayLink == nil && (self.timerStyle == .default || self.timerStyle == .displayLink) {
            
            let displayLink = CADisplayLink(
                target: self,
                selector: #selector(Tween.handleDisplayLink(_:))
            )
            displayLink.preferredFramesPerSecond = self.preferredFramesPerSecond
            displayLink.add(to: .current, forMode: .default)
            self.displayLink = displayLink
            
        } else if timer == nil && timerStyle == .timer {
            
            self.timer = Timer.scheduledTimer(
                timeInterval: self.timerInterval,
                target: self,
                selector: #selector(Tween.handleTimer),
                userInfo: nil,
                repeats: true
            )
            self.timer!.fire()
        }
    }
    
    fileprivate func stop() {
        
        if self.displayLink != nil {
            self.displayLink!.isPaused = true
            self.displayLink!.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
            self.displayLink = nil
        }
        
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    fileprivate func pause() {
        
        if self.paused && (self.timer != nil || self.displayLink != nil) {
            
            self.pausedTimeStamp = CACurrentMediaTime()
            stop()
            return
        }
        
        guard self.timer == nil && self.displayLink == nil
        else { return }
        
        guard let pausedTimeStamp = self.pausedTimeStamp else {
            
            self.pausedTimeStamp = nil
            start()
            return
        }
        
        let diff = CACurrentMediaTime() - pausedTimeStamp
        
        self.periods.forEach { period in
            period.set(startTimestamp: period.startTimestamp + diff)
        }
        
        start()
    }
    
    //Convience functions
    
    @discardableResult public func value<T: Tweenable>(
        start: T,
        end: T,
        duration: TimeInterval = 1
    ) -> Period<T> {
        let period = Period(start: start, end: end, duration: duration, delay: 0)
        add(period: period)
        return period
    }
}

