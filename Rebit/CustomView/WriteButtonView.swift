//
//  WriteButtonView.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import SwiftUI

struct WriteButtonView: View {
    var body: some View {
        Text("shelf-write-review".localized)
            .font(.callout.bold())
            .frame(width: 90, height: 35)
            .background(.theme)
            .foregroundStyle(.white)
            .clipShape(
                .rect(topLeadingRadius: 0, bottomLeadingRadius: 20, bottomTrailingRadius: 15, topTrailingRadius: 15)
            )
    }
}
