//
//  Font.swift
//  Rebit
//
//  Created by 홍정민 on 1/8/25.
//

import SwiftUI

enum FontName {
    static let navigation = "NanumBaeEunHyeCe"
}

extension Font {
    static let navigation: Font = .custom(FontName.navigation, size: 30)
}
