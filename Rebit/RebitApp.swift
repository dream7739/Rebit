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
    
    init() {
        setNavigationBarAppearance()
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
        appearance.backButtonAppearance = backButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = appearance
        
        UIBarButtonItem.appearance().tintColor = .navigation
    }
}
