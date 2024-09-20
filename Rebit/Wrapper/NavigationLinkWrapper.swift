//
//  NavigationLinkWrapper.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI

struct NavigationLinkWrapper<Dest: View, Inner: View> : View {
    let dest: Dest
    let inner: Inner
    
    init(@ViewBuilder dest: () -> Dest, @ViewBuilder inner: () -> Inner) {
        self.dest = dest()
        self.inner = inner()
    }
    
    var body: some View {
        NavigationLink {
            NavigationLazyView(dest)
        } label: {
            inner
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

