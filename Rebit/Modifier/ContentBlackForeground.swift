//
//  ContentBlackForeground.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI

struct ContentBlackForeground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
    }
}

extension View {
    func asContentBlackForeground() -> some View {
        modifier(ContentBlackForeground())
    }
}
