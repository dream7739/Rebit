//
//  TitleGrayForeground.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI

struct TitleGrayForeground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .foregroundStyle(.gray)
    }
}

extension View {
    func asTitleGrayForeground() -> some View {
        modifier(TitleGrayForeground())
    }
}
