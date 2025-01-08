//
//  Tab.swift
//  Rebit
//
//  Created by 홍정민 on 1/8/25.
//

import Foundation

enum TabType {
    case favorite
    case bookshelf
    case search
    case chart
    
    var icon: String {
        switch self {
        case .favorite:
            return "heart"
        case .bookshelf:
            return "text.book.closed"
        case .search:
            return "magnifyingglass"
        case .chart:
            return "chart.bar"
        }
    }
    
    var title: String {
        switch self {
        case .favorite:
            return "favorite".localized
        case .bookshelf:
            return "bookshelf".localized
        case .search:
            return "search".localized
        case .chart:
            return "chart".localized
        }
    }
}
