//
//  ToastView.swift
//  Rebit
//
//  Created by 홍정민 on 9/25/24.
//

import SwiftUI

struct ToastView: View {
    @Binding var isShow: Bool
    let message: String
    let closure: () -> Void
    
    init(isShow: Binding<Bool>, message: String, closure: @escaping () -> Void) {
        self._isShow = isShow
        self.message = message
        self.closure = closure
    }
    
    var body: some View {
        if isShow {
            Text(message)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundStyle(.white)
                .background(
                    Capsule()
                        .fill(.black.opacity(0.6))
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 40)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isShow.toggle()
                            closure()
                        }
                    }
                }
        }
    }
}
