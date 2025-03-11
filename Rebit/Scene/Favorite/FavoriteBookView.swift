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
                case .content(let reviewList), .updated(let reviewList):
                    favoriteCardView(reviewList)
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
            intent.onChangeStatus()
        }
    }
    
    func favoriteCardView(_ reviewList: [BookReviewContent]) -> some View {
        ForEach(Array(zip(reviewList.indices, reviewList)), id: \.1.id) { (index: Int, review: BookReviewContent) in
            NavigationLinkWrapper {
                BookReviewView.build(book: review.book, isActive: $isActive)
            } inner: {
                FavoriteContentView(
                    currentIndex: currentIndex,
                    index: index,
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
    var review: BookReviewContent
    @State var coverImage: UIImage?
    
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
        .onAppear {
            coverImage = try? ImageFileManager.shared.loadImageToDocument(filename: "\(review.book.id)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func headerView(_ width: CGFloat, _ height: CGFloat) -> some View {
        return VStack(alignment: .center, spacing: 6) {
            Image(uiImage: coverImage ?? UIImage())
                .resizable()
                .frame(width: width , height: height * 0.6)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(currentIndex == index ? 1.0 : 0.6)
                .scaleEffect(currentIndex == index ? 1.0 : 0.7)
                .padding(.bottom, 10)
            Text(review.book.title)
                .font(.callout.bold())
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .opacity(currentIndex == index ? 1 : 0)
            Text(review.book.author)
                .font(.subheadline)
                .opacity(currentIndex == index ? 1 : 0)
            
            HStack(alignment: .center, spacing: 4) {
                Image(.ratingFill)
                    .resizable()
                    .frame(width: 13, height: 12)
                    .foregroundStyle(.orange)
                Text(review.bookReview.ratingDescription)
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
            Text(review.bookReview.content)
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

