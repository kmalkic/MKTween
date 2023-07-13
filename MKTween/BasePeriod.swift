//
//  BasePeriod.swift
//  MKTween
//
//  Created by Kevin Malkic on 08/04/2019.
//  Copyright © 2019 Kevin Malkic. All rights reserved.
//

import Foundation

public protocol BasePeriod {
    
    func updateInternal() -> Bool
    
    var name: String { get }
    var paused: Bool { get }
    
    func pause()
    func resume()
    
    func callUpdateBlock()
    func callCompletionBlock()
    func callCancelledBlock()
    
    var delay: TimeInterval { get }
    var duration: TimeInterval { get }
    var startTimestamp: TimeInterval { get }
    var lastTimestamp: TimeInterval { get }
    
    func set(startTimestamp time: TimeInterval)
    @discardableResult func set(name: String) -> Self
}
