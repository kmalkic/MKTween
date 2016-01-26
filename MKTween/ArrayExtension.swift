//
//  ArrayExtension.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

extension Array {
    
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        
        for (idx, objectToCompare) in self.enumerate() {
            
            if let to = objectToCompare as? U {
                
                if object == to {
                    
                    self.removeAtIndex(idx)
                    
                    return true
                }
            }
        }
        
        return false
    }
}
