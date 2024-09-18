//
//  GreenRoundBackground.swift
//  Rebit
//
//  Created by 홍정민 on 9/18/24.
//

import SwiftUI

struct ThemeBasicButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(.theme)
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
            .foregroundStyle(.white)
    }
}

extension View {
    func asThemeBasicButtonModifier() -> some View {
        modifier(ThemeBasicButtonModifier())
    }
}
