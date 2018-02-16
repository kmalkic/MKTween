//
//  Tween.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

import Foundation

public enum TimerStyle : Int {
    
    case `default` //DisplayLink
    case displayLink
    case timer
    case none
}

open class Tween: NSObject {
    
    fileprivate var tweenOperations = [Any]()
    fileprivate var expiredTweenOperations = [Any]()
    fileprivate var pausedTimeStamp : TimeInterval?
    fileprivate var displayLink : CADisplayLink?
    fileprivate var timer: Timer?
    fileprivate var busy = false
    
    open var timerStyle: TimerStyle = .default {
        
        didSet {
            
            stop()
            start()
        }
    }
    
    /* When true the object is prevented from firing. Initial state is
    * false. */
    
    open var paused: Bool = false {
        
        didSet {
            
            pause()
        }
    }
    
    /* Defines how many display frames must pass between each time the
    * display link fires. Default value is one, which means the display
    * link will fire for every display frame. Setting the interval to two
    * will cause the display link to fire every other display frame, and
    * so on. The behavior when using values less than one is undefined. */
    
    open var frameInterval: Int = 1 {
        
        didSet {
            
            stop()
            start()
        }
    }
    
    open var timerInterval: TimeInterval = 1/60 {
        
        didSet {
            
            stop()
            start()
        }
    }
    
    deinit {
        
        stop()
    }
    
    open static let shared = Tween(.default)
    
    open class func shared(_ timerStyle: TimerStyle = .default, frameInterval: Int? = nil, timerInterval: TimeInterval? = nil) -> Tween {
        
        let instance = Tween(timerStyle, frameInterval: frameInterval, timerInterval: timerInterval)
        
        return instance
    }
    
    public init( _ timerStyle: TimerStyle = .default, frameInterval: Int? = nil, timerInterval: TimeInterval? = nil) {
        
        super.init()
        
        self.timerStyle = timerStyle
        self.frameInterval = frameInterval ?? self.frameInterval
        self.timerInterval = timerInterval ?? self.timerInterval
    }
    
    open func addTweenOperation<T>(_ operation: Operation<T>) {
        
        if operation.period.duration > 0 {
            
            self.tweenOperations.append(operation)
            
            start()
            
        } else {
            
            print("please set a duration")
        }
    }
    
    open func removeTweenOperation<T>(_ operation: Operation<T>) {
        
        _ = self.tweenOperations.removeOperation(operation)
    }
    
    open func removeTweenOperationByName(_ name: String) -> Bool {
        
        let copy = self.tweenOperations
                
        for operation in copy {
            
            if let operation = operation as? Operation<Double>, operation.name == name {
                
                removeTweenOperation(operation)
                
                return true
                
            } else if let operation = operation as? Operation<CGFloat>, operation.name == name {
                
                removeTweenOperation(operation)
                
                return true
                
            } else if let operation = operation as? Operation<Float>, operation.name == name {
                
                removeTweenOperation(operation)
                
                return true
            }
        }
        
        return false
    }
    
    open func removeAllOperations() {
        
        self.tweenOperations.removeAll()
    }
    
    open func hasOperations() -> Bool {
        
        return self.tweenOperations.count > 0
    }
    
    fileprivate func progressOperation<T>(_ timeStamp: TimeInterval, operation: Operation<T>) {
        
        let period = operation.period
        
        if let startTimeStamp = period.startTimeStamp {
            
            if period.hasStarted(timeStamp) {
                
                if !period.hasEnded(timeStamp) {
                    
                    let progress = operation.timingFunction(timeStamp - startTimeStamp - period.delay, period.startValue.toDouble(), period.endValue.toDouble() - period.startValue.toDouble(), period.duration)
                    
                    period.progress = T(progress)
                    
                } else {
                    
                    period.progress = period.endValue
                    self.expiredTweenOperations.append(operation)
                    removeTweenOperation(operation)
                }
                
                period.updatedTimeStamp = timeStamp
                
                if let updateBlock = operation.updateBlock {
                    
                    if let dispatchQueue = operation.dispatchQueue {
                        
                        dispatchQueue.async(execute: { () -> Void in
                            
                            updateBlock(period)
                        })
                        
                    } else {
                        
                        updateBlock(period)
                    }
                }
            }
            
        } else {
            
            period.setStartTimeStamp(timeStamp)
        }
    }
    
    fileprivate func expiryOperation<T>(_ operation: Operation<T>) -> Operation<T> {
        
        if let completeBlock = operation.completeBlock {
            
            if let dispatchQueue = operation.dispatchQueue {
                
                dispatchQueue.async(execute: { () -> Void in
                    
                    completeBlock()
                })
                
            } else {
                
                completeBlock()
            }
        }
        
        return operation
    }
    
    open func update(_ timeStamp: TimeInterval) {
        
        if self.tweenOperations.count == 0 {
            
            stop()
            
            return
        }
        
        let copy = self.tweenOperations
        
        for operation in copy {
            
            if let operation = operation as? Operation<Double> {
                
                progressOperation(timeStamp, operation: operation)
                
            } else if let operation = operation as? Operation<CGFloat> {
                
                progressOperation(timeStamp, operation: operation)
                
            } else if let operation = operation as? Operation<Float> {
                
                progressOperation(timeStamp, operation: operation)
            }
        }
        
        let expiredCopy = self.expiredTweenOperations
        
        for operation in expiredCopy {
            
            if let operation = operation as? Operation<Double> {
                
                 _ = self.expiredTweenOperations.removeOperation(expiryOperation(operation))
                
            } else if let operation = operation as? Operation<CGFloat> {
                
                _ = self.expiredTweenOperations.removeOperation(expiryOperation(operation))
                
            } else if let operation = operation as? Operation<Float> {
                
                _ = self.expiredTweenOperations.removeOperation(expiryOperation(operation))
            }
        }
    }
    
    @objc func handleDisplayLink(_ sender: CADisplayLink) {
        
        handleTick(sender.timestamp)
    }
    
    @objc func handleTimer(_ sender: Timer) {
        
        handleTick(CACurrentMediaTime())
    }
    
    fileprivate func handleTick(_ timeStamp: TimeInterval) {
        
        if self.busy {
            
            return
        }
        
        self.busy = true
        
        update(timeStamp)
        
        self.busy = false
    }
    
    fileprivate func start() {
        
        if self.tweenOperations.count == 0 || self.paused {
            
            return
        }
        
        if self.displayLink == nil && (self.timerStyle == .default || self.timerStyle == .displayLink) {
            
            self.displayLink = UIScreen.main.displayLink(withTarget: self, selector: #selector(Tween.handleDisplayLink(_:)))
            self.displayLink!.frameInterval = self.frameInterval
            self.displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            
        } else if timer == nil && timerStyle == .timer {
            
            self.timer = Timer.scheduledTimer(timeInterval: self.timerInterval, target: self, selector: #selector(Tween.handleTimer(_:)), userInfo: nil, repeats: true)
            self.timer!.fire()
        }
    }
    
    fileprivate func stop() {
        
        if self.displayLink != nil {
            
            self.displayLink!.isPaused = true
            self.displayLink!.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
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
            
        } else if self.timer == nil && self.displayLink == nil {
            
            if let pausedTimeStamp = self.pausedTimeStamp {
                
                let diff = CACurrentMediaTime() - pausedTimeStamp
                
                for operation in self.tweenOperations {
                    
                    if let operation = operation as? Operation<Double>, let startTimeStamp = operation.period.startTimeStamp {
                        
                        operation.period.setStartTimeStamp(startTimeStamp + diff)
                     
                    } else if let operation = operation as? Operation<CGFloat>, let startTimeStamp = operation.period.startTimeStamp {
                        
                        operation.period.setStartTimeStamp(startTimeStamp + diff)
                        
                    } else if let operation = operation as? Operation<Float>, let startTimeStamp = operation.period.startTimeStamp {
                        
                        operation.period.setStartTimeStamp(startTimeStamp + diff)
                    }
                }
            }
            
            self.pausedTimeStamp = nil
            
            start()
        }
    }
    
    //Convience functions
    
    public func value<T: BinaryFloatingPoint>(duration: TimeInterval, startValue: T = 0, endValue: T = 1) -> Operation<T> {
    
        let period = Period(duration: duration, delay: 0, startValue: startValue, endValue: endValue)
        
        let operation = Operation(period: period)
        
        addTweenOperation(operation)
        
        return operation
    }
}
