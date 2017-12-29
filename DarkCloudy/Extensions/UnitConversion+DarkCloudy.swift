//
//  UnitConversion+DarkCloudy.swift
//  DarkCloudy
//
//  Created by Scott moon on 28/12/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import Foundation

extension Double {
    
    func toCelcius() -> Double {
        return ((self - 32.0) / 1.8)
    }
    
    func toKPH() -> Double {
        return (self * 1.609344)
    }
}
