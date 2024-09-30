//
//  CircularProgressView.swift
//  Rebit
//
//  Created by 홍정민 on 9/30/24.
//

import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    
    var body: some View {
        let progressText = String(format: "%.0f%%", progress * 100)
        
        ZStack {
            Circle()
                .stroke(Color(.systemGray4), lineWidth: 15)
            Circle()
                .trim(from: 0, to: CGFloat(self.progress))
                .stroke(
                    .theme,
                    style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .overlay(
                Text(progressText)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(.systemGray))
                )
        }
        .frame(width: 100, height: 100)
        .padding()
    }
}

#Preview {
    CircularProgressView(progress: 0.7)
}
