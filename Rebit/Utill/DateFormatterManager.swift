//
//  DateFormatterManager.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import Foundation

enum DateFormatterManager {
    enum DateFormat: String {
        case basic = "yyyy.MM.dd"
    }
    
    static let basicFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.basic.rawValue
        return dateFormatter
    }()
    
    static let emptyDateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    static func dateCompare(_ start: Date, _ end: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: start, to: end).day
    }
    
}
