//
//  HorizontalPageWrapper.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI

struct HorizontalPageWrapper: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .scrollTargetBehavior(.paging)
        } else {
            content
                .onAppear {
                    UIScrollView.appearance().isPagingEnabled = true
                }
        }
    }
}

struct HorizontalPageContentWrapper<Inner: View>: ViewModifier {
    let height: CGFloat
    let inner: Inner
    
    init(height: CGFloat, @ViewBuilder inner: () -> Inner) {
        self.height = height
        self.inner = inner()
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    inner
                        .containerRelativeFrame(.horizontal)
                        .frame(height: height)
                }
                .scrollTargetLayout()
            }
            .asHorizontalPage()
        } else {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        inner
                            .frame(width: proxy.size.width, height: height)
                    }
                }
            }
            .asHorizontalPage()
        }
        
    }

}

extension View {
    func asHorizontalPage() -> some View{
        modifier(HorizontalPageWrapper())
    }
    
    func asHorizontalPageContent(
        height: CGFloat, 
        @ViewBuilder inner: () -> some View
    ) -> some View {
        modifier(HorizontalPageContentWrapper(height: height, inner: inner))
    }
}
