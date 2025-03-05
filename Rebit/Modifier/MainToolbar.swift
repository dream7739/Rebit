//
//  MainToolbar.swift
//  Rebit
//
//  Created by 홍정민 on 1/8/25.
//

import SwiftUI

struct MainToolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(.mainLogo)
                            .resizable()
                            .frame(width: 26, height: 35)
                        Text(Literal.appName)
                            .font(.navigation)
                    }
                }
            }
            .toolbarBackground(.toolbarBackground, for: .navigationBar)
    }
}

extension View {
    func asMainToolbar() -> some View {
        modifier(MainToolbar())
    }
}
