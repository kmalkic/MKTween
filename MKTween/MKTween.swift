//
//  MKTween.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Malkic Kevin. All rights reserved.
//

import Foundation

public enum MKTweenTimerStyle : Int {
    
    case `default` //DisplayLink
    case displayLink
    case timer
    case none
}

open class MKTween: NSObject {
    
    fileprivate var tweenOperations = [MKTweenOperation]()
    fileprivate var expiredTweenOperations = [MKTweenOperation]()
    fileprivate var pausedTimeStamp : TimeInterval?
    fileprivate var displayLink : CADisplayLink?
    fileprivate var timer: Timer?
    fileprivate var busy = false
    
    open var timerStyle: MKTweenTimerStyle = .default {
        
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
    
    open static let shared = MKTween(.default)
    
    open class func shared(_ timerStyle: MKTweenTimerStyle = .default, frameInterval: Int? = nil, timerInterval: TimeInterval? = nil) -> MKTween {
        
        let instance = MKTween(timerStyle, frameInterval: frameInterval, timerInterval: timerInterval)
        
        return instance
    }
    
    public init( _ timerStyle: MKTweenTimerStyle = .default, frameInterval: Int? = nil, timerInterval: TimeInterval? = nil) {
        
        super.init()
        
        self.timerStyle = timerStyle
        self.frameInterval = frameInterval ?? self.frameInterval
        self.timerInterval = timerInterval ?? self.timerInterval
    }
    
    open func addTweenOperation(_ operation: MKTweenOperation) {
        
        if operation.period.duration > 0 {
            
            tweenOperations.append(operation)
            
            start()
        }
    }
    
    open func removeTweenOperation(_ operation: MKTweenOperation) {
        
        _ = tweenOperations.removeOperation(operation)
    }
    
    open func removeAllOperations() {
        
        let copy = tweenOperations
        
        for operation in copy {
            
            removeTweenOperation(operation)
        }
    }
    
    open func hasOperations() -> Bool {
        
        return tweenOperations.count > 0
    }
    
    open func update(_ timeStamp: TimeInterval) {
        
        if tweenOperations.count == 0 {
            
            stop()
            
            return
        }
        
        let copy = tweenOperations
        
        for operation in copy {
            
            let period = operation.period
            
            if let startTimeStamp = period.startTimeStamp {
                
                let timeToStart = startTimeStamp + period.delay
                
                if timeStamp >= timeToStart {
                    
                    let timeToEnd = startTimeStamp + period.delay + period.duration
                    
                    if timeStamp <= timeToEnd {
                        
                        period.progress = operation.timingFunction(timeStamp - startTimeStamp - period.delay, period.startValue, period.endValue - period.startValue, period.duration)
                        
                    } else {
                        
                        period.progress = period.endValue
                        expiredTweenOperations.append(operation)
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
                
                period.startTimeStamp = timeStamp
            }
        }
        
        let expiredCopy = expiredTweenOperations
        
        for operation in expiredCopy {
            
            if let completeBlock = operation.completeBlock {
                
                if let dispatchQueue = operation.dispatchQueue {
                    
                    dispatchQueue.async(execute: { () -> Void in
                        
                        completeBlock()
                    })
                    
                } else {
                    
                    completeBlock()
                }
            }
            
            _ = expiredTweenOperations.removeOperation(operation)
        }
    }
    
    @objc func handleDisplayLink(_ sender: CADisplayLink) {
        
        handleTick(sender.timestamp)
    }
    
    @objc func handleTimer(_ sender: Timer) {
        
        handleTick(CACurrentMediaTime())
    }
    
    fileprivate func handleTick(_ timeStamp: TimeInterval) {
        
        if busy {
            
            return
        }
        
        busy = true
        
        update(timeStamp)
        
        busy = false
    }
    
    fileprivate func start() {
        
        if tweenOperations.count == 0 || paused {
            
            return
        }
        
        if displayLink == nil && (timerStyle == .default || timerStyle == .displayLink) {
            
            displayLink = UIScreen.main.displayLink(withTarget: self, selector: #selector(MKTween.handleDisplayLink(_:)))
            displayLink!.frameInterval = frameInterval
            displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            
        } else if timer == nil && timerStyle == .timer {
            
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(MKTween.handleTimer(_:)), userInfo: nil, repeats: true)
            timer!.fire()
        }
    }
    
    fileprivate func stop() {
        
        if displayLink != nil {
            
            displayLink!.isPaused = true
            displayLink!.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
            displayLink = nil
        }
        
        if timer != nil {
            
            timer!.invalidate()
            timer = nil
        }
    }
    
    fileprivate func pause() {
        
        if paused && (timer != nil || displayLink != nil) {
            
            pausedTimeStamp = CACurrentMediaTime()
            
            stop()
            
        } else if timer == nil && displayLink == nil {
            
            if let pausedTimeStamp = pausedTimeStamp {
                
                let diff = CACurrentMediaTime() - pausedTimeStamp
                
                let operationsStarted = tweenOperations.filter({ (operation) -> Bool in
                    
                    return operation.period.startTimeStamp != nil
                })
                
                for operation in operationsStarted {
                    
                    operation.period.startTimeStamp! += diff
                }
            }
            
            pausedTimeStamp = nil
            
            start()
        }
    }
}
