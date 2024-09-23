//
//  FavoriteViewModel.swift
//  Rebit
//
//  Created by 홍정민 on 9/22/24.
//

import Foundation
import Combine
import RealmSwift

final class FavoriteViewModel: BaseViewModel {
    struct Input {
    }
    
    struct Output {
    }
    
    var input = Input()
    @Published var output = Output()
    var cancellables = Set<AnyCancellable>()
    
    @ObservedResults(BookReview.self, where: { $0.isLike } )
    var favorite
    
    init() {
        transform()
    }
    
    func transform() {
        
        
    }
}
