//
//  BookShelfViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import Foundation
import SwiftUI
import Combine

final class BookShelfViewModel: BaseViewModel {
    struct Input {
    }
    
    struct Output {
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    private let repository = RealmRepository()
    private let fileManager = ImageFileManager.shared
    
    init() {
        transform()
    }
    
    func transform() {
      
    }
}

extension BookShelfViewModel {
    func retriveImage(_ id: String) -> UIImage {
        if let image = fileManager.loadImageToDocument(filename: "\(id)") {
            return image
        } else {
            return UIImage()
        }
    }
}
