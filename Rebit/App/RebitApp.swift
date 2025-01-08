//
//  RebitApp.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

@main
struct RebitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        setNavigationBarAppearance()
        setTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension RebitApp {
    private func setNavigationBarAppearance() {
        let backButtonAppearance = UIBarButtonItemAppearance()
        let appearance = UINavigationBarAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backButtonAppearance = backButtonAppearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UIBarButtonItem.appearance().tintColor = .navigation
    }
    
    private func setTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .toolbarBackground
        appearance.shadowColor = .clear
        appearance.stackedLayoutAppearance.selected.iconColor = .theme
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.theme]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

