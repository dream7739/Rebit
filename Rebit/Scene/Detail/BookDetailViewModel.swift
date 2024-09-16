//
//  BookDetailViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/16/24.
//

import Foundation
import Combine

final class BookDetailViewModel: BaseViewModel, ObservableObject {
    
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    func transform() {
        
    }
    
    init() {
        transform()
    }
}

extension BookDetailViewModel {
    
}
