//
//  BasePeriods.swift
//  MKTween
//
//  Created by Kevin Malkic.
//  Copyright © 2024 Kevin Malkic. All rights reserved.
//

import Foundation

public protocol BasePeriods: BasePeriod {
    
    var periods: [BasePeriod] { get }
    
    func tweenCount() -> Int
}

extension BasePeriods {
    
    public func tweenCount() -> Int {
        var count = 0
        periods.forEach { period in
            if let period = period as? Sequence {
                count += period.tweenCount()
            } else {
                count += 1
            }
        }
        return count
    }
    
    public func pause() {
        periods.forEach {
            $0.pause()
        }
    }
    
    public func resume() {
        periods.forEach {
            $0.resume()
        }
    }
}
