//
//  Double.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation

extension Double {
    
    ///
    /// Convert double to one-decimal string
    ///
    /// Examples:
    /// ```
    /// 8.70000 = 8.7
    /// ```
    func toOneDecimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        
        let number = NSNumber(value: self)
    
        return numberFormatter.string(from: number) ?? ""
    }
}
