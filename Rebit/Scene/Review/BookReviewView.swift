//
//  BookReviewView.swift
//  Rebit
//
//  Created by 홍정민 on 9/20/24.
//

import SwiftUI

struct BookReviewView: View {
    @StateObject var container: MVIContainer<BookReviewIntentProtocol, BookReviewModelStateProtocol>
    private var state: BookReviewModelStateProtocol { container.model }
    private var intent: BookReviewIntentProtocol { container.intent }
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            reviewBackgroundView()
            reviewContentView()
        }
        .toolbarRole(.editor)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            intent.viewOnAppear()
        }
        .onReceive(state.dismissTrigger) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func reviewBackgroundView() -> some View {
        Rectangle()
            .fill(
                .theme.opacity(0.4)
            )
            .ignoresSafeArea()
    }
    
    func reviewContentView() -> some View {
        GeometryReader { proxy in
            asHorizontalPageContent(height: proxy.size.height) {
                ForEach(state.reviewList, id: \.self) { review in
                    BookReviewContentView(container: container, review: review)
                }
            }
        }
    }
}

struct BookReviewContentView: View {
    @ObservedObject var container: MVIContainer<BookReviewIntentProtocol, BookReviewModelStateProtocol>
    private var state: BookReviewModelStateProtocol { container.model }
    private var intent: BookReviewIntentProtocol { container.intent }
    let review: BookReview
    
    @State var isFullPresented: Bool = false
    @State var isShowingAlert: Bool = false
    @Environment(\.colorScheme) var color
    
    var body: some View {
        VStack {
            bookInfoView()
            Divider()
            reviewStatusView()
            Divider()
            reviewContentView()
            Spacer()
        }
        .fullScreenCover(isPresented: $isFullPresented,
                         onDismiss: {
            intent.updateTrigger(review)
        }) {
            BookWriteView.build(
                viewType: .edit,
                review: review,
                isFullPresented: $isFullPresented
            )
        }
        .alert("review-delete-title".localized, isPresented: $isShowingAlert) {
            Button("review-delete-ok".localized, role: .none) {
                intent.deleteReviewClicked(review)
            }
            Button("review-delete-cancel".localized, role: .cancel) { }
        }
        .frame(maxWidth: .infinity)
        .background(
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 30, topTrailing: 30))
                .fill(color == .light ? .white : .black)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 10, y: 5)
        )
        .padding(.trailing, 20)
        .padding(.vertical)
    }
    
    func bookInfoView() -> some View {
        VStack {
            Image(uiImage: state.bookCover)
                .resizable()
                .frame(width: 120, height: 160)
                .padding(.top, 10)
            Text(state.book.title)
                .font(.callout.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            Text(state.book.author)
                .asContentBlackForeground()
                .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .overlay(alignment: .topTrailing) {
            optionMenuView()
        }
    }
    
    func optionMenuView() -> some View {
        HStack(alignment: .center, spacing: 4) {
            Button(action: {
                intent.isLikeClicked(review)
            }, label: {
                if review.isLike {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(color == .light ? .red : .white)
                        .imageScale(.large)
                } else {
                    Image(systemName: "heart")
                        .foregroundStyle(color == .light ? .black : .white)
                        .imageScale(.large)
                }
            })
            optionMenu()
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
    
    func optionMenu() -> some View {
        Menu {
            Button("menu-edit".localized, action: {
                isFullPresented = true
            })
            
            Button("menu-delete".localized, action: {
                isShowingAlert = true
            })
            
            NavigationLinkWrapper {
                let book = state.book
                BookDetailView(
                    book: Book(
                        title: book.title,
                        image: "",
                        author: book.author,
                        publisher: book.publisher,
                        pubdate: book.pubdate,
                        isbn: book.isbn,
                        description: book.content),
                    coverImage: state.bookCover
                )
            } inner: {
                Button("menu-detail".localized, action: {})
            }
        } label: {
            Image(.dotList)
                .frame(width: 30, height: 30)
        }
    }
    
    func reviewStatusView() -> some View {
        HStack {
            infoBoxView(
                "review-status-title".localized,
                Literal.ReadingStatus(rawValue: review.status)?.title ?? ""
            )
            infoBoxView("review-rating".localized, review.ratingDescription)
            infoBoxView("review-count".localized, state.book.reviewCountDescription)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 65)
    }
    
    func infoBoxView(_ title: String, _ content: String) -> some View {
        Rectangle()
            .fill(color == .light ? .white : .black)
            .overlay(alignment: .center) {
                VStack(alignment: .center, spacing: 4) {
                    Text(title)
                        .asTitleGrayForeground()
                    
                    if title == "review-rating".localized && content != "-" {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.orange)
                            Text(content)
                                .font(.callout.bold())
                        }
                    } else {
                        Text(content)
                            .font(.callout.bold())
                    }
                }
            }
    }
    
    func reviewContentView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if Literal.ReadingStatus(rawValue: review.status) == .expected {
                contentView("review-comment".localized, review.title)
                contentView("review-expected-date".localized, review.startDateDescription)
                contentView("review-save-date".localized, review.saveDateDescription)
            } else {
                contentView("review-comment".localized, review.title)
                contentView("review-content".localized, review.content)
                contentView("review-date".localized, review.readingDateDescription)
                contentView("review-save-date".localized, review.saveDateDescription)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
    
    func contentView(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .asTitleGrayForeground()
            Text(content)
                .asContentBlackForeground()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension BookReviewView {
    static func build(book: BookInfo) -> some View {
        let model = BookReviewModel(book: book)
        let intent = BookReviewIntent(
            model: model,
            bookRepository: DefaultBookRepository(),
            reviewRepository: DefaultReviewRepository(),
            fileManager: ImageFileManager.shared
        )
        let container = MVIContainer(
            intent: intent as BookReviewIntentProtocol,
            model: model as BookReviewModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = BookReviewView(container: container)
        return view
    }
}
