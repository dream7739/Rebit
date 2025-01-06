//
//  MainTabItem.swift
//  Rebit
//
//  Created by 홍정민 on 1/6/25.
//

import SwiftUI

struct MainTabItem: ViewModifier {
    let tabType: TabType
    
    init(tabType: TabType) {
        self.tabType = tabType
    }
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                Image(systemName: tabType.icon)
                Text(tabType.title)
            }
    }
}

extension View {
    func asMainTabItem(_ tabType: TabType) -> some View {
        modifier(MainTabItem(tabType: tabType))
    }
}

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
