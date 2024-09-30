//
//  Date+.swift
//  Rebit
//
//  Created by 홍정민 on 9/30/24.
//

import Foundation

extension Date {
    static func startOfMonth(for month: Int, of year: Int, using calendar: Calendar = .current) -> Date? {
        DateComponents(calendar: calendar, year: year, month: month).date
    }
}
