//
//  MainTabView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI

// MainTabView.swift
// 태그를 통해 selectedTab에 선택한 탭 인덱스 넘김
struct MainTabView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var color
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FavoriteBookView.build()
                .asMainTabItem(.favorite)
                .tag(0)
            
            BookShelfView()
                .asMainTabItem(.bookshelf)
                .tag(1)
            
            BookSearchView.build()
                .asMainTabItem(.search)
                .tag(2)
            
            BookChartView()
                .asMainTabItem(.chart)
                .tag(3)
        }
    }
}
