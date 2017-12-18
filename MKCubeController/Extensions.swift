//
//  Extensions.swift
//  MKCubeController
//
//  Created by Kevin Malkic on 27/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

extension Array {
	
	mutating internal func removeObject<U: Equatable>(object: U) -> Bool {
		
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

extension Dictionary {
    
    mutating internal func removeObject<U: Equatable>(object: U) -> Bool {
        
        for (key, objectToCompare) in self {
            
            if let to = objectToCompare as? U {
                
                if object == to {
                    
                    self.removeValue(forKey: key)
                    
                    return true
                }
            }
        }
        
        return false
    }
}

extension UIViewController {
	
	public var cubeViewController: MKCubeViewController? {
		
		get {
			
            if let parentCubeViewController = parent as? MKCubeViewController {
				
				return parentCubeViewController
			}
			
			return parent?.cubeViewController
		}
	}
}
