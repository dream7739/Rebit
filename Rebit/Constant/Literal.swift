//
//  Literal.swift
//  Rebit
//
//  Created by 홍정민 on 1/8/25.
//

import Foundation

enum Literal {
    static let appName = "Rebbit"

    enum ReadingStatus: Int, CaseIterable {
        case expected = 0
        case current
        case completed
        
        var title: String {
            switch self {
            case .expected:
                return "reading-expected".localized
            case .current:
                return "reading-current".localized
            case .completed:
                return "reading-completed".localized
            }
        }
        
        var endDateTitle: String {
            switch self {
            case .expected:
                return ""
            case .current:
                return "write-goal-end-date".localized
            case .completed:
                return "write-end-date".localized
            }
        }
        
        var summaryTitle: String {
            switch self {
            case .expected:
                return "write-expected-title".localized
            case .current, .completed:
                return "write-summary-title".localized
            }
        }
    }

}
