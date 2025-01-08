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
