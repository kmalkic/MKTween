//
//  BinaryFloatingPointExtension.swift
//  MKTween
//
//  Created by Kevin Malkic on 14/12/2017.
//  Copyright © 2017 Kevin Malkic. All rights reserved.
//

extension BinaryFloatingPoint {
    
    public func toDouble() -> Double {
        
        return Double(self)
    }
}

extension Double {
    
    public init<T: BinaryFloatingPoint>(_ other: T) {
        
        if let value = other as? Double {
            
            self.init(value)
            
        } else if let value = other as? Float {
            
            self.init(value)
            
        } else if let value = other as? CGFloat {
            
            self.init(value)
            
        } else {
            
            self.init(0)
        }
    }
    
    public func ToDouble() -> Double {
        
        return self
    }
}

extension Float {
    
    public init<T: BinaryFloatingPoint>(_ other: T) {
        
        if let value = other as? Double {
            
            self.init(value)
            
        } else if let value = other as? Float {
            
            self.init(value)
            
        } else if let value = other as? CGFloat {
            
            self.init(value)
            
        } else {
            
            self.init(0)
        }
    }
}

extension CGFloat {
    
    public init<T: BinaryFloatingPoint>(_ other: T) {
        
        if let value = other as? Double {
            
            self.init(value)
            
        } else if let value = other as? Float {
            
            self.init(value)
            
        } else if let value = other as? CGFloat {
            
            self.init(value)
            
        } else {
            
            self.init(0)
        }
    }
}
