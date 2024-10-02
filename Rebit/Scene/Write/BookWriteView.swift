//
//  BookWriteView.swift
//  Rebit
//
//  Created by 홍정민 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct BookWriteView: View {
    @StateObject private var viewModel: BookWriteViewModel
    @State private var isShow: Bool = false
    @State private var rating = 5.0
    @State private var viewType: ViewType
    @Binding var isFullPresented: Bool
    @FocusState private var focusedField: Field?
    @Environment(\.colorScheme) var color
    
    //책 상세화면에서 진입했을 경우
    init(book: Book?, isFullPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: BookWriteViewModel(book: book))
        self._isFullPresented = isFullPresented
        self.viewType = .add
    }
    
    //책 리뷰화면에서 진입했을 경우
    init(bookReview: BookReview?, isFullPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: BookWriteViewModel(bookReview: bookReview))
        self._isFullPresented = isFullPresented
        self.rating = bookReview?.rating ?? 5.0
        self.viewType = .edit
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                switch ReadingStatus(rawValue: viewModel.output.selectedStatus)! {
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
            ToastView(isShow: $isShow, message: viewType.toastMessage) {
                isFullPresented = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.input.viewOnAppear.send(())
        }
        .onReceive(viewModel.output.dismissRequest) { _ in
            isShow = true
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
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
    private enum Field: Hashable {
        case title
        case content
        case initial
    }
    
    private enum ViewType {
        case add
        case edit
        
        var toastMessage: String {
            switch self {
            case .add:
                return "저장되었습니다"
            case .edit:
                return "수정되었습니다"
            }
        }
    }
}

extension BookWriteView {
    func titleView() -> some View {
        HStack {
            Text("이 책은 어떤 책인가요?")
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
            Text("독서 상태를 알려주세요")
                .font(.subheadline)
            HStack {
                ForEach(ReadingStatus.allCases, id: \.self) { item in
                    StatusCardView(
                        selectedIndex: $viewModel.output.selectedStatus,
                        index: item.rawValue
                    )
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func ratingView() -> some View {
        VStack(alignment: .leading) {
            Text("평점을 매겨주세요")
                .font(.subheadline)
            CustomCosmosView(rating: $rating)
                .onTapGesture(count: 999999) { }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    //독서예정일 경우 -> startDate만 존재
    //독서중, 독서완료일 경우 -> startDate, endDate가 존재
    func dateView() -> some View {
        VStack(alignment: .leading) {
            let status = ReadingStatus(rawValue: viewModel.output.selectedStatus)!
            
            Text("독서한 기간을 알려주세요")
                .font(.subheadline)
            
            switch status {
            case .expected:
                DatePicker(
                    "독서예정일",
                    selection: $viewModel.output.startDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .font(.subheadline)
                .onTapGesture(count: 999999) { }
            case .current, .completed:
                DatePicker(
                    "시작일",
                    selection: $viewModel.output.startDate,
                    displayedComponents: .date
                )
                .font(.subheadline)
                .onTapGesture(count: 999999) { }
                DatePicker(
                    status.endDateTitle,
                    selection: $viewModel.output.endDate,
                    in: viewModel.output.startDate...,
                    displayedComponents: .date
                )
                    .font(.subheadline)
                    .onTapGesture(count: 999999) { }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func summaryView() -> some View {
        VStack(alignment: .leading) {
            let status = ReadingStatus(rawValue: viewModel.output.selectedStatus)!
            
            Text(status.summaryTitle)
                .font(.subheadline)
            
            TextField("이 책을 한줄로 정의해보세요", text: $viewModel.output.summaryText)
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
            Text("전체적인 감상평을 남겨보세요")
                .font(.subheadline)
            
            TextEditor(text: $viewModel.output.reviewText)
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
                    Text("책을 읽은 후의 감상을 적어보세요")
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.6))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 13)
                        .opacity(viewModel.output.reviewText.isEmpty ? 1.0 : 0)
                }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func writeButton() -> some View {
        Button(action: {
            //별점정보
            viewModel.rating = rating
            
            //저장정보
            switch viewType {
            case .add:
                viewModel.input.saveReview.send(())
            case .edit:
                viewModel.input.modifyReview.send(())
            }
        }, label: {
            Text("작성하기")
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
            Text(ReadingStatus.allCases[index].title)
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


#Preview {
    BookWriteView(
        book: Book(
            title: "",
            image: "",
            author: "",
            publisher: "",
            pubdate: "",
            isbn: "",
            description: ""
        ),
        isFullPresented: .constant(true)
    )
}
