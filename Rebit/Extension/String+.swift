//
//  String+.swift
//  Rebit
//
//  Created by 홍정민 on 10/3/24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
