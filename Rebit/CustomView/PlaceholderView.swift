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
        case goal
    }
    
    var text: String
    var type: ViewType
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(text)
                .foregroundStyle(.gray)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      
    }
}
