//
//  MainTabView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI


struct MainTabView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var color
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom){
                TabView(selection: $selectedTab) {
                    FavoriteBookView()
                        .tag(0)
                    BookShelfView()
                        .tag(1)
                    BookSearchView.build()
                        .tag(2)
                    BookChartView()
                        .tag(3)
                }
                .toolbar(.hidden, for: .tabBar)
                
                HStack {
                    ForEach(TabItems.allCases, id: \.self) { item in
                        Button(action: {
                            selectedTab = item.rawValue
                        }, label: {
                            customTabItem(imageName: item.icon, title: item.title, isActive: (selectedTab == item.rawValue))
                        })
                    }
                }
                .frame(height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(color == .light ? .white : .black)
                        .shadow(color: color == .light ? .gray.opacity(0.2) : .white.opacity(0.4), radius: 2)
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            }
            .navigationTitle(TabItems(rawValue: selectedTab)!.title)
            .ignoresSafeArea()
        }
    }
}

extension MainTabView {
    private enum TabItems: Int, CaseIterable {
        case favorite = 0
        case shelf = 1
        case search = 2
        case chart = 3
        
        var title: String {
            switch self {
            case .favorite:
                return "favorite".localized
            case .shelf:
                return "bookshelf".localized
            case .search:
                return "search".localized
            case .chart:
                return "chart".localized
            }
        }
        
        var icon: String {
            switch self {
            case .favorite:
                return "heart"
            case .shelf:
                return "text.book.closed"
            case .search:
                return "magnifyingglass"
            case .chart:
                return "chart.bar"
            }
        }
    }
    
    private func customTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .foregroundStyle(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(height: 60)
        .frame(maxWidth: isActive ? .infinity: 60)
        .background(isActive ? .theme.opacity(0.4) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    MainTabView()
}
