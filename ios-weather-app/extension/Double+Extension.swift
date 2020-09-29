//
//  Double+Extension.swift
//  ios-weather-app
//
//  Created by Swapnali Kulkarni on 26/09/20.
//  Copyright © 2020 Swapnali Kulkarni. All rights reserved.
//

import Foundation

extension Double{
    
    func toString() -> String {
        return String(format: "%.1f", self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}
