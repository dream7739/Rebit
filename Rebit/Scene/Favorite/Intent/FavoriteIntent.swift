//
//  FavoriteIntent.swift
//  Rebit
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation


protocol FavoriteIntentProtocol: AnyObject {
    func viewOnAppear()
}

final class FavoriteIntent: FavoriteIntentProtocol {
    let model: FavoriteModel
    let repository: ReviewRepository
    
    init(model: FavoriteModel, repository: ReviewRepository) {
        self.model = model
        self.repository = repository
    }
    
    func viewOnAppear() {
        let favoriteList = repository.fetchFavoriteList()
        if favoriteList.isEmpty {
            model.displayNoResult()
        } else {
            model.updateContent(favorite: favoriteList)
        }
    }
    
}
