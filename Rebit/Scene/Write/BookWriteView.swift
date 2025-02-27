//
//  BookWriteView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI
import RealmSwift

enum Field: Hashable {
    case title
    case content
    case initial
}

struct BookWriteView: View {
    @StateObject var container: MVIContainer<BookWriteIntentProtocol, BookWriteModelStateProtocol>
    private var state: BookWriteModelStateProtocol { container.model }
    private var intent: BookWriteIntentProtocol { container.intent }
    
    @State private var isShow: Bool = false
    @State private var rating = 5.0
    @Binding var isFullPresented: Bool
    @FocusState private var focusedField: Field?
    @Environment(\.colorScheme) var color
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                switch Literal.ReadingStatus(rawValue: state.selectedStatus)! {
                case .expected:
                    expectedView()
                case .current:
                    currentView()
                case .completed:
                    completeView()
                }
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            ToastView(isShow: $isShow, message: state.viewType.toastMessage) {
                isFullPresented = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            intent.viewOnAppear()
        }
        .onReceive(state.dismissRequest) { _ in
            isShow = true
        }
        .onSubmit {
            switch focusedField {
            case .title:
                focusedField = .content
            default:
                print("default")
            }
        }
    }
    
    // 독서예정
    func expectedView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            titleView()
            readingStatusView()
            dateView()
            summaryView()
            writeButton()
            Spacer()
        }
    }
    
    // 독서중
    func currentView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            titleView()
            readingStatusView()
            ratingView()
            dateView()
            summaryView()
            reviewView()
            writeButton()
            Spacer()
        }
    }
    
    // 독서완료
    func completeView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            titleView()
            readingStatusView()
            ratingView()
            dateView()
            summaryView()
            reviewView()
            writeButton()
            Spacer()
        }
    }
}

extension BookWriteView {
    func titleView() -> some View {
        HStack {
            Text("write-title".localized)
                .font(.system(size: 20).bold())
            Spacer()
            Button(action: {
                isFullPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(color == .light ? .black : .white)
            })
            .frame(alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func readingStatusView() -> some View {
        VStack(alignment: .leading) {
            Text("write-status".localized)
                .font(.subheadline)
            HStack {
                ForEach(Literal.ReadingStatus.allCases, id: \.self) { item in
                    StatusCardView(
                        selectedIndex: container.binding(for: \.selectedStatus),
                        index: item.rawValue
                    )
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func ratingView() -> some View {
        VStack(alignment: .leading) {
            Text("write-rating".localized)
                .font(.subheadline)
            CustomCosmosView(rating: $rating)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // 독서예정일 경우: startDate만 존재
    // 독서중, 독서완료일 경우: startDate, endDate가 존재
    func dateView() -> some View {
        VStack(alignment: .leading) {
            let status = Literal.ReadingStatus(rawValue: state.selectedStatus)!
            
            Text("write-period".localized)
                .font(.subheadline)
            
            switch status {
            case .expected:
                DatePicker(
                    "review-expected-date".localized,
                    selection: container.binding(for: \.startDate),
                    in: Date()...,
                    displayedComponents: .date
                )
                .font(.subheadline)
                .onTapGesture(count: 999999) { }
            case .current, .completed:
                DatePicker(
                    "write-start-date".localized,
                    selection: container.binding(for: \.startDate),
                    displayedComponents: .date
                )
                .font(.subheadline)
                DatePicker(
                    status.endDateTitle,
                    selection: container.binding(for: \.endDate),
                    in: state.startDate...,
                    displayedComponents: .date
                )
                .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func summaryView() -> some View {
        VStack(alignment: .leading) {
            let status = Literal.ReadingStatus(rawValue: state.selectedStatus)!
            
            Text(status.summaryTitle)
                .font(.subheadline)
            
            TextField(
                "write-summary-empty".localized,
                text: container.binding(for: \.summaryText)
            )
            .font(.footnote)
            .tint(.theme)
            .padding(10)
            .focused($focusedField, equals: .title)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            .frame(height: 35)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func reviewView() -> some View {
        VStack(alignment: .leading) {
            Text("write-review-title".localized)
                .font(.subheadline)
            
            TextEditor(text: container.binding(for: \.reviewText))
                .font(.footnote)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .tint(.theme)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .focused($focusedField, equals: .content)
                .overlay(alignment: .topLeading) {
                    Text("write-review-empty".localized)
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.6))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 13)
                        .opacity(state.reviewText.isEmpty ? 1.0 : 0)
                }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func writeButton() -> some View {
        Button(action: {
            //별점정보
            state.rating = rating
            intent.saveReviewClicked()
        }, label: {
            Text("write-save".localized)
                .asThemeBasicButtonModifier()
        })
    }
}

struct StatusCardView: View {
    @Binding var selectedIndex: Int
    @Environment(\.colorScheme) var color
    
    var index: Int
    
    var body: some View {
        Button(action: {
            selectedIndex = index
        }, label: {
            Text(Literal.ReadingStatus.allCases[index].title)
                .font(.footnote)
                .padding(.vertical, 8)
                .padding(.horizontal, 13)
                .background(selectedIndex == index ? .theme : color == .light ? .white : .black)
                .foregroundStyle(selectedIndex == index ? .white : color == .light ? .black : .white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(selectedIndex == index ? .clear: .gray.opacity(0.4), lineWidth: 1)
                )
        })
        .buttonStyle(PlainButtonStyle())
    }
}

extension BookWriteView {
    static func build(
        viewType: WriteViewType,
        book: Book? = nil,
        review: BookReview? = nil,
        isFullPresented: Binding<Bool>
    ) -> some View {
        let model = BookWriteModel(
            viewType: viewType,
            book: book,
            review: review
        )
        let intent = BookWriteIntent(
            model: model,
            bookRepository: DefaultBookRepository(),
            reviewRepository: DefaultReviewRepository()
        )
        let view = BookWriteView(
            container: MVIContainer(
                intent: intent as BookWriteIntentProtocol,
                model: model as BookWriteModelStateProtocol,
                modelChangePublisher: model.objectWillChange
            ),
            isFullPresented: isFullPresented
        )
        return view
    }
}
