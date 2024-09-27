//
//  PlaceholderView.swift
//  Rebit
//
//  Created by 홍정민 on 9/27/24.
//

import SwiftUI

struct PlaceholderView: View {
    enum ViewType {
        case search
        case shelf
    }
    
    @Binding var text: String
    var type: ViewType
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            switch type {
            case .search:
                Image(.search)
            case .shelf:
                Image(.placeholder)
            }
            Text(text)
                .foregroundStyle(.gray)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
      
    }
}

#Preview {
    PlaceholderView(text: .constant("아직 등록한 책이 없어요"), type: .shelf)
}
