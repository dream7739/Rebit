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
    @State private var isActive: Bool = false
    private var state: FavoriteModelStateProtocol { container.model }
    private var intent: FavoriteIntentProtocol { container.intent }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                switch state.contentState {
                case .content(let reviewList, let bookList):
                    favoriteCardView(reviewList, bookList)
                case .noResult:
                    PlaceholderView(text: state.placeholder, type: .shelf)
                }
            }
            .asMainToolbar()
        }
        .onAppear {
            intent.viewOnAppear()
        }
        .onChange(of: isActive) { newValue in
            intent.viewOnAppear()
        }
    }
    
    func favoriteCardView(_ reviewList: [BookReview], _ bookList: [Book]) -> some View {
        ForEach(Array(zip(reviewList.indices, reviewList)), id: \.0) {
            (index: Int, review: BookReview) in
            
            NavigationLinkWrapper {
                BookReviewView.build(book: bookList[index], isActive: $isActive)
            } inner: {
                FavoriteContentView(
                    currentIndex: currentIndex,
                    index: index,
                    book: bookList[index],
                    review: review
                )
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
                                    currentIndex = min(reviewList.count - 1, currentIndex + 1)
                                }
                            }
                        }
                )
            }
        }
    }
}

struct FavoriteContentView: View {
    var currentIndex: Int
    var index: Int
    var book: Book
    var review: BookReview
    
    @GestureState var dragOffset: CGFloat = 0
    var widthRatio = 2.3
    var heightRatio = 0.8
    
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.height * heightRatio) / widthRatio
            let height = proxy.size.height * heightRatio
            
            VStack(alignment: .center, spacing: 10) {
                headerView(width, height)
                descriptionView()
                Spacer()
            }
            .frame(width: width, height: height)
            .frame(maxWidth: .infinity, alignment: .center)
            .offset(x: CGFloat(index - currentIndex) * width + dragOffset, y: 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func headerView(_ width: CGFloat, _ height: CGFloat) -> some View {
        VStack(alignment: .center, spacing: 6) {
            Image(uiImage: ImageFileManager.shared.loadImageToDocument(filename: "\(book.id)") ?? UIImage())
                .resizable()
                .frame(width: width , height: height * 0.6)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(currentIndex == index ? 1.0 : 0.6)
                .scaleEffect(currentIndex == index ? 1.0 : 0.7)
                .padding(.bottom, 10)
            Text(book.title)
                .font(.callout.bold())
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .opacity(currentIndex == index ? 1 : 0)
            Text(book.author)
                .font(.subheadline)
                .opacity(currentIndex == index ? 1 : 0)
            
            HStack(alignment: .center, spacing: 4) {
                Image(.ratingFill)
                    .resizable()
                    .frame(width: 13, height: 12)
                    .foregroundStyle(.orange)
                Text(review.ratingDescription)
                    .font(.caption)
                    .foregroundStyle(.theme)
            }
            .opacity(currentIndex == index ? 1 : 0)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func descriptionView() -> some View {
        VStack(alignment: .center) {
            Text(review.content)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
                .asTitleGrayForeground()
                .opacity(currentIndex == index ? 1 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

extension FavoriteBookView {
    static func build() -> some View {
        let model = FavoriteModel()
        let intent = FavoriteIntent(
            model: model,
            repository: DefaultReviewRepository()
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

