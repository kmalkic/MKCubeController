//
//  Extensions.swift
//  MKCubeController
//
//  Created by Kevin Malkic on 27/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

extension Array {
	
	mutating internal func removeObject<U: Equatable>(object: U) -> Bool {
		
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

extension Dictionary {
    
    mutating internal func removeObject<U: Equatable>(object: U) -> Bool {
        
        for (key, objectToCompare) in self {
            
            if let to = objectToCompare as? U {
                
                if object == to {
                    
                    self.removeValueForKey(key)
                    
                    return true
                }
            }
        }
        
        return false
    }
}