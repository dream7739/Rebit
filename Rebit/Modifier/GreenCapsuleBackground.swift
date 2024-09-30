//
//  GreenCapsuleBackground.swift
//  Rebit
//
//  Created by 홍정민 on 9/30/24.
//

import SwiftUI

struct GreenCapsuleBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote.bold())
            .foregroundStyle(.white)
            .padding()
            .background(
                Capsule()
                    .fill(.theme)
                    .frame(width: 70, height: 30)
            )
    }
}

extension View {
    func asGreenCapsuleBackground() -> some View {
        modifier(GreenCapsuleBackground())
    }
}
