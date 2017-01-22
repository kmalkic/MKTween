//
//  ArrayExtension.swift
//  MKTween
//
//  Created by Kevin Malkic on 25/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

extension Array {
    
    mutating internal func removeOperation<U: Equatable>(_ object: U) -> Bool {
        
        for (idx, objectToCompare) in self.enumerated() {
            
            if let to = objectToCompare as? U {
                
                if object == to {
                    
                    self.remove(at: idx)
                    
                    return true
                }
            }
        }
        
        return false
    }
}
