//
//  Extensions.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 12/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var mainColor = UIColor(red: 0/255, green: 151/255, blue: 205/255, alpha: 1)
}


extension Date {
    
    /// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    /// - Returns: A `Date` object
    static func from(year: Int = 2000, month: Int = 01, day: Int = 01) -> Date? {
        
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        return calendar.date(from: dateComponents) ?? nil
    }
}
