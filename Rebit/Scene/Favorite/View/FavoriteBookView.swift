//
//  FavoriteBookView.swift
//  Rebit
//
//  Created by 홍정민 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct FavoriteBookView: View {
    @StateObject var container: MVIContainer<FavoriteIntentProtocol, FavoriteModelStateProtocol>
    @State private var currentIndex: Int = 0
    private var state: FavoriteModelStateProtocol { container.model }
    private var intent: FavoriteIntentProtocol { container.intent }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            switch state.contentState {
            case .content(let favorite):
                favoriteCardView(favorite)
            case .noResult:
                PlaceholderView(text: state.placeholder, type: .shelf)
            }
        }
        .onAppear {
            intent.viewOnAppear()
        }
    }
}

extension FavoriteBookView {
    func favoriteCardView(_ favorite: [BookReview]) -> some View {
        ForEach(Array(zip(favorite.indices, favorite)), id: \.0) {
            (index: Int, item: BookReview) in
            
            NavigationLinkWrapper {
                if let book = item.book.first {
                    BookReviewView(bookInfo: book)
                }
            } inner: {
                FavoriteContentView(currentIndex: currentIndex, index: index, item: item)
                    .gesture (
                        DragGesture()
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                if value.translation.width > threshold {
                                    withAnimation {
                                        currentIndex = max(0, currentIndex - 1)
                                    }
                                } else if value.translation.width < -threshold {
                                    withAnimation {
                                        currentIndex = min(favorite.count - 1, currentIndex + 1)
                                    }
                                }
                            }
                    )
            }
        }
    }
}

extension FavoriteBookView {
    static func build() -> some View {
        let model = FavoriteModel()
        let intent = FavoriteIntent(
            model: model,
            repository: ReviewRepository()
        )
        let container = MVIContainer(
            intent: intent as FavoriteIntentProtocol,
            model: model as FavoriteModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = FavoriteBookView(container: container)
        return view
    }
}

