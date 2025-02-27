//
//  WriteViewType.swift
//  Rebit
//
//  Created by 홍정민 on 2/26/25.
//

import Foundation

// WriteViewType
// 신규 생성 or 수정
enum WriteViewType {
    case add
    case edit
    
    var toastMessage: String {
        switch self {
        case .add:
            return "write-toast-save".localized
        case .edit:
            return "write-toast-update".localized
        }
    }
}
