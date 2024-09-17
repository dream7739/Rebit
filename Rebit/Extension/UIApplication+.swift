//
//  UIApplication+.swift
//  Rebit
//
//  Created by 홍정민 on 9/17/24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
