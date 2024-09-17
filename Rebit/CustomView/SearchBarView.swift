//
//  SearchBarView.swift
//  Rebit
//
//  Created by 홍정민 on 9/17/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            TextField("검색할 책을 입력하세요", text: $text)
                .autocorrectionDisabled(true)
                .foregroundStyle(.black)
                .tint(.theme)
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.gray)
                .opacity(text.isEmpty ? 0 : 1)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    text = ""
                }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.1))
        )
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
